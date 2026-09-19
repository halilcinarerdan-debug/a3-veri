--[[
    chemistry_core.lua
    Molar kutle / stokiyometri tabanli reaksiyon motoru + ekzotermik
    termal kacis (thermal runaway) fizigi.

    NOT: Config.Recipes icindeki reaktif etiketleri ve katsayilari
    kurgusaldir; gercek bir yasadisi madde uretim prosedurunu temsil
    etmez (bkz. config.lua basligi).
]]

ChemistryCore = {}

local ReactorState = {}
local KELVIN = Config.Thermal.kelvinOffset
local PURITY_DECAY_K = 2.4

local function clamp(v, lo, hi)
    if v < lo then return lo elseif v > hi then return hi end
    return v
end

local function GetRecipe(recipeKey)
    return Config.Recipes[recipeKey]
end

local function GetReactorDef(reactorId)
    return Config.Reactors[reactorId]
end

-- ==================================================================
-- KATMAN 1 KOPRUSU
-- Sert bagimlilik degildir: kaynak calismiyorsa veya export patlarsa
-- notr fallback biyometri kullanilir, motor bagimsiz calismaya devam eder.
-- ==================================================================
local function GetAgentBiometrics(citizenId)
    if GetResourceState(Config.Bridge.Layer1Resource) == 'started' then
        local ok, result = pcall(function()
            return exports[Config.Bridge.Layer1Resource]:GetAgentBiometrics(citizenId)
        end)
        if ok and type(result) == 'table' then
            return result
        end
    end
    return Config.Bridge.FallbackBiometrics
end

-- Yuksek kortizol / yoksunluk siddeti, mg bazli dozajlamada fizyolojik
-- bir titreme sapmasi uretir. Bu bir "basari sansi" zari degildir:
-- genlik biyometriye deterministik baglidir, yalnizca yonu (fazla/eksik
-- dozlama) her eklemede degisebilir.
local function GetDosingErrorAmplitude(biometrics)
    local cortisolStress = math.max(0, (biometrics.cortisol or 12.0) - 12.0) / 40.0
    local withdrawalStress = biometrics.withdrawal or 0.0
    return clamp(cortisolStress * 0.6 + withdrawalStress * 0.9, 0.0, 0.85)
end

function ChemistryCore.InitReactor(reactorId)
    if ReactorState[reactorId] then return end
    local def = GetReactorDef(reactorId)
    if not def then return end

    ReactorState[reactorId] = {
        recipeKey = nil,
        charges = {},              -- item -> toplam yuklenen mg
        ownerCitizenId = nil,
        tempC = def.ambientTempC,
        pressurePsi = 14.7,
        coolantValve = 0,
        wearRatio = ChemistryCore.LoadEquipmentWear(reactorId),
        running = false,
        runawaySeconds = 0.0,
        ph = 7.0,
        destroyed = false,
    }
end

function ChemistryCore.LoadEquipmentWear(reactorId)
    local wear = 0.0
    local ok, rows = pcall(function()
        return exports.oxmysql:executeSync('SELECT wear_ratio FROM layer3_equipment WHERE reactor_id = ? LIMIT 1', { reactorId })
    end)
    if ok and rows and rows[1] then
        wear = tonumber(rows[1].wear_ratio) or 0.0
    end
    return clamp(wear, 0.0, 1.0)
end

function ChemistryCore.SaveEquipmentWear(reactorId, wear)
    wear = clamp(wear, 0.0, 1.0)
    exports.oxmysql:execute([[
        INSERT INTO layer3_equipment (reactor_id, wear_ratio, last_updated)
        VALUES (?, ?, NOW())
        ON DUPLICATE KEY UPDATE wear_ratio = VALUES(wear_ratio), last_updated = NOW()
    ]], { reactorId, wear })
end

-- ==================================================================
-- REAKTIF YUKLEME
-- ==================================================================
function ChemistryCore.ChargeReagent(reactorId, citizenId, itemName, massMg)
    local state = ReactorState[reactorId]
    if not state or state.running or state.destroyed then return false, 'reactor_unavailable' end
    if massMg == nil or massMg <= 0 then return false, 'invalid_mass' end

    local amplitude = GetDosingErrorAmplitude(GetAgentBiometrics(citizenId))
    local noise = (math.random() * 2.0 - 1.0) * amplitude * 0.5
    local effectiveMassMg = math.max(0.0, massMg * (1.0 + noise))

    state.charges[itemName] = (state.charges[itemName] or 0.0) + effectiveMassMg
    state.ownerCitizenId = state.ownerCitizenId or citizenId

    return true, effectiveMassMg
end

local function CalculateMoles(massMg, molarMass)
    if not molarMass or molarMass <= 0 then return 0.0 end
    return (massMg / 1000.0) / molarMass
end

-- Her reaktifin gercek mol/ideal-oran biriminin, en kisitlayici
-- (limiting) reaktifin biriminden goreli sapmasini toplar ve pH
-- dengesini hesaplar. Basit toplama degil, stokiyometrik oran analizidir.
function ChemistryCore.EvaluateStoichiometry(reactorId)
    local state = ReactorState[reactorId]
    local recipe = state and GetRecipe(state.recipeKey)
    if not state or not recipe then return nil end

    local moles = {}
    local ratioUnits = {}
    local ph = 7.0

    for _, reagent in ipairs(recipe.reagents) do
        local massMg = state.charges[reagent.item] or 0.0
        local n = CalculateMoles(massMg, reagent.molarMass)
        moles[reagent.item] = n
        ratioUnits[reagent.item] = n / reagent.idealMolarRatio

        if reagent.phWeight then
            local saturation = math.min(1.0, n / math.max(0.001, reagent.idealMolarRatio))
            ph = ph + reagent.phWeight * saturation
        end
    end

    local limitingUnits = nil
    for _, u in pairs(ratioUnits) do
        if limitingUnits == nil or u < limitingUnits then limitingUnits = u end
    end
    limitingUnits = limitingUnits or 0.0

    local totalDeviation = 0.0
    for _, u in pairs(ratioUnits) do
        if limitingUnits > 0.0 then
            totalDeviation = totalDeviation + math.abs(u - limitingUnits) / limitingUnits
        elseif u > 0.0 then
            totalDeviation = totalDeviation + 1.0
        end
    end

    state.ph = clamp(ph, 0.0, 14.0)

    return {
        moles = moles,
        limitingUnits = limitingUnits,
        totalDeviation = totalDeviation,
        ph = state.ph,
    }
end

-- Saflik endeksi stokiyometrik sapmayla LOGARITMIK olarak coker:
-- purity = 100 / (1 + ln(1 + k * sapma))  ->  kucuk hatalarda yumusak,
-- buyuk hatalarda hizla sifira yaklasan bir egri.
function ChemistryCore.CalculatePurityIndex(totalDeviation)
    return clamp(100.0 / (1.0 + math.log(1.0 + PURITY_DECAY_K * totalDeviation)), 0.0, 100.0)
end

function ChemistryCore.StartSynthesis(reactorId, citizenId, recipeKey)
    ChemistryCore.InitReactor(reactorId)
    local state = ReactorState[reactorId]
    local recipe = GetRecipe(recipeKey)
    if not state or not recipe or state.running or state.destroyed then return false end

    state.recipeKey = recipeKey
    state.running = true
    state.runawaySeconds = 0.0
    return true
end

function ChemistryCore.SetCoolantValve(reactorId, percent)
    local state = ReactorState[reactorId]
    if not state then return end
    state.coolantValve = clamp(tonumber(percent) or 0, 0, 100)
end

function ChemistryCore.GetReactorState(reactorId)
    return ReactorState[reactorId]
end

function ChemistryCore.GetTelemetry(reactorId)
    local state = ReactorState[reactorId]
    if not state then return nil end
    return {
        tempC = state.tempC,
        pressurePsi = state.pressurePsi,
        ph = state.ph,
        coolantValve = state.coolantValve,
        wearRatio = state.wearRatio,
        running = state.running,
        runawaySeconds = state.runawaySeconds,
        destroyed = state.destroyed,
    }
end

-- ==================================================================
-- ISI TRANSFERI / BASINC DONGUSU (fizik tick basina cagrilir)
-- ==================================================================
local T = Config.Thermal

-- Van't Hoff / Q10 kinetik yaklasimi: reaksiyon hizi sicaklikla ustel
-- artar (rate = base * Q10^((T-Tref)/interval)). Hiz arttikca uretilen
-- isi da artar -> pozitif geri besleme, yani termal kacisin matematiksel
-- kokeni burasidir.
local function ReactionRate(recipe, tempC)
    local exponent = (tempC - recipe.referenceTempC) / recipe.q10IntervalC
    return recipe.baseRateConstant * (recipe.q10Coefficient ^ exponent)
end

function ChemistryCore.PhysicsTick(reactorId, dtSeconds)
    local state = ReactorState[reactorId]
    local def = GetReactorDef(reactorId)
    if not state or not def or not state.running or state.destroyed then return end

    local recipe = GetRecipe(state.recipeKey)
    if not recipe then return end

    local eval = ChemistryCore.EvaluateStoichiometry(reactorId)
    local limitingMoles = eval and eval.limitingUnits or 0.0

    local rate = ReactionRate(recipe, state.tempC) * math.max(0.001, limitingMoles)
    local heatGeneratedW = rate * recipe.exothermicCoefficient

    -- Sogutma bir esanjor gibi davranir: transfer edilen guc, reaktorun
    -- ortam sicakliginin NE KADAR UZERINDE oldugu ile orantilidir. Reaktor
    -- ortam sicakligina indiginde (veya altina duserse) sogutma etkisi
    -- sifira duser -- boylece sistem fiziksel olarak imkansiz bir sekilde
    -- ortamin altina sonsuza dek sogumaz.
    local deltaAboveAmbient = math.max(0.0, state.tempC - def.ambientTempC)
    local conductanceWPerC = T.passiveConductanceWPerC + (state.coolantValve / 100.0) * T.coolantConductanceWPerC
    local coolingW = conductanceWPerC * deltaAboveAmbient

    local netHeatW = heatGeneratedW - coolingW
    state.tempC = state.tempC + (netHeatW * dtSeconds) / T.thermalMassJPerC

    -- Basinc iki bilesenden olusur:
    --  1) Gay-Lussac (sabit hacim, P/T = sabit): P2 = P1 * (T2[K] / T1[K]).
    --     Bu bilesen tek basina asla kap patlama basincina ulasmaz (ideal
    --     gazin sicaklikla dogrusal genlesmesi cok kucuktur).
    --  2) Kritik esigin (criticalTempC) UZERINDEKI buhar/ayrisma basinci
    --     surgesi: Clausius-Clapeyron benzeri, sicaklikla ustel tirmanan
    --     bir egri. Gercek termal kacis kazalarinda (ör. kontrolsuz
    --     reaktor infilaklari) asiri basincin asil kaynagi budur, ideal
    --     gaz genlesmesi degil.
    local tK = state.tempC + KELVIN
    local baseK = def.ambientTempC + KELVIN
    local gayLussacPsi = 14.7 * (tK / baseK)

    local overshootC = math.max(0.0, state.tempC - T.criticalTempC)
    local vaporSurgePsi = 1.6 * (overshootC ^ 1.3)

    state.pressurePsi = gayLussacPsi + vaporSurgePsi

    if state.tempC >= T.runawayTempC then
        state.runawaySeconds = state.runawaySeconds + dtSeconds
        state.wearRatio = clamp(state.wearRatio + Config.Equipment.wearPerRunawaySecond * dtSeconds, 0.0, 1.0)
    else
        state.runawaySeconds = 0.0
    end

    -- Deterministik conta sizintisi: asinma * basinc farki. Sans/zar
    -- mekanigi YOKTUR; bakimsiz (yuksek wearRatio) bir reaktor normal
    -- basincta bile surekli, olculebilir bir akiya sahiptir.
    local pressureDelta = math.max(0.0, state.pressurePsi - 14.7)
    local leakFlux = Config.Equipment.sealPermeabilityConst * state.wearRatio * pressureDelta
    if leakFlux > 0.0 then
        CBRNSimulation.RegisterLeak(def.interiorId, leakFlux, recipe.outputGasType)
    end

    if state.pressurePsi >= def.vesselRatedPsi then
        ChemistryCore.RuptureVessel(reactorId)
    end
end

function ChemistryCore.RuptureVessel(reactorId)
    local state = ReactorState[reactorId]
    local def = GetReactorDef(reactorId)
    if not state or state.destroyed then return end

    state.destroyed = true
    state.running = false

    local recipe = GetRecipe(state.recipeKey)
    local c = def.coords

    AddExplosion(c.x, c.y, c.z, 15, 1.4, true, false, 0.0)

    CBRNSimulation.RegisterLeak(def.interiorId, Config.CBRN.explosionGasSpike, recipe and recipe.outputGasType or 'TOXIC_ANALOG_A')
    CBRNSimulation.MarkExplosionOrigin(def.interiorId, c)

    state.wearRatio = 1.0
    ChemistryCore.SaveEquipmentWear(reactorId, state.wearRatio)

    exports.oxmysql:execute(
        'INSERT INTO layer3_synthesis_log (reactor_id, citizenid, purity_index, yield_mg, outcome, created_at) VALUES (?, ?, ?, ?, ?, NOW())',
        { reactorId, state.ownerCitizenId, 0.0, 0.0, 'explosion' }
    )

    if GetResourceState(Config.Bridge.Layer2Resource) == 'started' then
        TriggerEvent('layer2_cybercomm:financial:recordTransaction', {
            citizenid = state.ownerCitizenId,
            currency = 'XMR',
            amount = -(Config.Equipment.maintenanceXmrCost * 3.0),
            reason = 'lab_reactor_explosion',
        })
    end

    TriggerEvent('layer3_industrial_chem:server:reactorDestroyed', reactorId)

    state.charges = {}
    state.recipeKey = nil
end

function ChemistryCore.FinalizeSynthesis(reactorId)
    local state = ReactorState[reactorId]
    if not state or not state.running or state.destroyed then return nil end

    local eval = ChemistryCore.EvaluateStoichiometry(reactorId)
    local recipe = GetRecipe(state.recipeKey)
    local purity = ChemistryCore.CalculatePurityIndex(eval.totalDeviation)
    local yieldMg = recipe.baseYieldMgPerMol * eval.limitingUnits * (purity / 100.0)
    local outcome = purity >= 55.0 and 'success' or 'contaminated'

    state.running = false
    state.wearRatio = clamp(state.wearRatio + Config.Equipment.wearPerCycle, 0.0, 1.0)
    ChemistryCore.SaveEquipmentWear(reactorId, state.wearRatio)

    exports.oxmysql:execute(
        'INSERT INTO layer3_synthesis_log (reactor_id, citizenid, purity_index, yield_mg, outcome, created_at) VALUES (?, ?, ?, ?, ?, NOW())',
        { reactorId, state.ownerCitizenId, purity, yieldMg, outcome }
    )

    if outcome == 'success' and GetResourceState(Config.Bridge.Layer2Resource) == 'started' then
        local xmrValue = (yieldMg / 1000.0) * (purity / 100.0) * 4.2
        TriggerEvent('layer2_cybercomm:financial:recordTransaction', {
            citizenid = state.ownerCitizenId,
            currency = 'XMR',
            amount = xmrValue,
            reason = 'lab_synthesis_yield',
        })
    end

    state.charges = {}
    state.recipeKey = nil

    return { purity = purity, yieldMg = yieldMg, outcome = outcome }
end
