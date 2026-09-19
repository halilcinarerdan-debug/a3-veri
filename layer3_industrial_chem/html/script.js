(function () {
    const root = document.getElementById('scada');
    const statusBadge = document.getElementById('status-badge');
    const logLine = document.getElementById('log-line');

    const valTemp = document.getElementById('val-temp');
    const valPressure = document.getElementById('val-pressure');
    const valPh = document.getElementById('val-ph');
    const valPpm = document.getElementById('val-ppm');

    const barTemp = document.getElementById('bar-temp');
    const barPressure = document.getElementById('bar-pressure');
    const barPh = document.getElementById('bar-ph');
    const barPpm = document.getElementById('bar-ppm');
    const barWear = document.getElementById('bar-wear');

    const valveSlider = document.getElementById('valve-slider');
    const valveValue = document.getElementById('valve-value');
    const ventBtn = document.getElementById('btn-ventilation');

    let ventilationOn = false;

    function post(endpoint, payload) {
        fetch(`https://layer3_industrial_chem/${endpoint}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(payload || {}),
        }).catch(() => {});
    }

    function clampPct(value, max) {
        if (!max) return 0;
        return Math.max(0, Math.min(100, (value / max) * 100));
    }

    function setStatus(t) {
        statusBadge.classList.remove('status-idle', 'status-running', 'status-critical', 'status-destroyed');
        if (t.destroyed) {
            statusBadge.textContent = 'REAKTOR IMHA OLDU';
            statusBadge.classList.add('status-destroyed');
        } else if (t.runawaySeconds > 0) {
            statusBadge.textContent = 'TERMAL KACIS';
            statusBadge.classList.add('status-critical');
        } else if (t.running) {
            statusBadge.textContent = 'SENTEZ SURUYOR';
            statusBadge.classList.add('status-running');
        } else {
            statusBadge.textContent = 'BEKLEMEDE';
            statusBadge.classList.add('status-idle');
        }
    }

    function updateTelemetry(t) {
        valTemp.textContent = `${t.tempC.toFixed(1)} °C`;
        valPressure.textContent = `${t.pressurePsi.toFixed(1)} PSI`;
        valPh.textContent = t.ph.toFixed(2);
        valPpm.textContent = `${Math.round(t.ppm || 0)} PPM`;

        barTemp.style.width = `${clampPct(t.tempC, 160)}%`;
        barTemp.style.backgroundColor = t.tempC >= 110 ? '#d15c5c' : '#5c9bd1';

        const vesselPsi = t.vesselRatedPsi || 185;
        barPressure.style.width = `${clampPct(t.pressurePsi, vesselPsi)}%`;
        barPressure.style.backgroundColor = t.pressurePsi >= vesselPsi * 0.85 ? '#d15c5c' : '#d7b95c';

        barPh.style.width = `${clampPct(t.ph, 14)}%`;

        barPpm.style.width = `${clampPct(t.ppm || 0, 100)}%`;
        barPpm.style.backgroundColor = (t.ppm || 0) >= 50 ? '#d15c5c' : '#6fae6f';

        barWear.style.width = `${(t.wearRatio || 0) * 100}%`;
        barWear.style.backgroundColor = (t.wearRatio || 0) >= 0.7 ? '#d15c5c' : '#8a8f96';

        valveSlider.value = t.coolantValve || 0;
        valveValue.textContent = `${t.coolantValve || 0}%`;

        setStatus(t);

        if (t.destroyed) {
            logLine.textContent = 'KRITIK ARIZA: KAP INFILAK ETTI. BOLGE KONTAMINE.';
        } else if (t.runawaySeconds > 0) {
            logLine.textContent = `TERMAL KACIS: ${t.runawaySeconds.toFixed(1)} sn. SOGUTMAYI ARTIRIN.`;
        }
    }

    window.addEventListener('message', (event) => {
        const data = event.data || {};
        if (data.action === 'open') {
            root.classList.remove('hidden');
            logLine.textContent = `REAKTOR AKTIF: ${data.reactorId}`;
        } else if (data.action === 'close') {
            root.classList.add('hidden');
        } else if (data.action === 'telemetry') {
            updateTelemetry(data.data);
        } else if (data.action === 'result') {
            const r = data.data;
            logLine.textContent = `SONUC: ${r.outcome.toUpperCase()} | SAFLIK ${r.purity.toFixed(1)}% | VERIM ${r.yieldMg.toFixed(1)} mg`;
        }
    });

    document.getElementById('btn-close').addEventListener('click', () => {
        root.classList.add('hidden');
        post('close');
    });

    valveSlider.addEventListener('input', () => {
        valveValue.textContent = `${valveSlider.value}%`;
        post('setValve', { percent: Number(valveSlider.value) });
    });

    ventBtn.addEventListener('click', () => {
        ventilationOn = !ventilationOn;
        ventBtn.classList.toggle('active', ventilationOn);
        ventBtn.textContent = ventilationOn ? 'ACIK' : 'KAPALI';
        post('toggleVentilation', { state: ventilationOn });
    });

    document.getElementById('btn-maintenance').addEventListener('click', () => {
        post('performMaintenance');
        logLine.textContent = 'BAKIM ISTEGI GONDERILDI.';
    });

    document.getElementById('btn-charge').addEventListener('click', () => {
        const item = document.getElementById('reagent-select').value;
        const massMg = Number(document.getElementById('reagent-mass').value);
        if (!massMg || massMg <= 0) return;
        post('chargeReagent', { item, massMg });
        logLine.textContent = `${massMg} mg ${item} reaktore yuklendi.`;
    });

    document.getElementById('btn-start').addEventListener('click', () => {
        post('startSynthesis', { recipeKey: 'synth_alpha' });
        logLine.textContent = 'SENTEZ BASLATILDI.';
    });

    document.getElementById('btn-finalize').addEventListener('click', () => {
        post('finalizeSynthesis');
        logLine.textContent = 'URUN TOPLANIYOR...';
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            root.classList.add('hidden');
            post('close');
        }
    });
})();
