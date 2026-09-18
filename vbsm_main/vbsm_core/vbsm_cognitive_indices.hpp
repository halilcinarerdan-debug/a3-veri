#define CIV_INDEX_UID         0
#define CIV_INDEX_CLASS       1
#define CIV_INDEX_KABILE      2
#define CIV_INDEX_INVENTORY   3
#define CIV_INDEX_ROUTINE     4
#define CIV_INDEX_HOME        5
#define CIV_INDEX_WORK        6
#define CIV_INDEX_HEALTH      7
#define CIV_INDEX_FATIGUE     8

// --- KATMAN 2 ENTEGRASYONU ---
#define CIV_INDEX_PERSONALITY 9  // [KorkuEşigi, İtaatEgilimi, MilliyetciAsilik, RusvetYatkinligi] -> Statik (0..1)
#define CIV_INDEX_EMOTION     10 // [AnlikKorku, OyuncuyaGuven, YerelOfke] -> Dinamik (0..1)
#define CIV_INDEX_MEMORY      11 // [[GorulenOlaylar], [BilinenIstihbarat]] -> Istihbarat Havuzu
#define CIV_INDEX_BELIEF      12 // [KabileBagliligi, FraksiyonSempatisi] -> Yari-statik (-1..1)
#define CIV_INDEX_INTENT      13 // [MevcutHedefEylem, Oncelik] -> Dinamik Karar
