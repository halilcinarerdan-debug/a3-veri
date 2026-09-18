/*
    KATMAN 2 | NUI CLIENT SCRIPT
    ShadowLine :: Arayuz Render + EXIF/Metadata Adli Analiz Cozucusu

    Notlar:
    - Bu dosya SADECE sunucudan gelen state'i ekrana basar. Bakiye, mesaj
      icerigi, EXIF verisi gibi hicbir "gercek" deger burada UYDURULMAZ;
      hepsi server.lua tarafindan uretilip syncState/newMessage/newDeadDrop/
      walletUpdate olaylariyla NUI'ye push edilir.
    - Fotograf balonlarindaki GPS/cihaz/zaman verileri dogrudan gorunmez;
      data-* ozniteliklerinde saklanir ve sadece oyuncu EXIF panelini
      actiginda okunup formatlanir (tik/sag-tik ile).
    - Koordinatlar OTOMATIK olarak haritaya/GPS'e islenmez; oyuncu bunlari
      elle okuyup oyun-ici GPS cihazina/haritasina kendisi girmelidir.
*/

const state = {
    channelId: null,
    channelName: '',
    messages: [],
    wallet: { balance: 0 },
};

function qs(selector) {
    return document.querySelector(selector);
}

function el(tag, className, text) {
    const node = document.createElement(tag);
    if (className) node.className = className;
    if (text !== undefined) node.textContent = text;
    return node;
}

function getResourceName() {
    return (typeof GetParentResourceName === 'function')
        ? GetParentResourceName()
        : 'layer2_cybercomm';
}

function fetchNui(endpoint, data) {
    return fetch(`https://${getResourceName()}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {}),
    }).catch(() => {});
}

// ============ NUI MESAJ YONLENDIRME ============

window.addEventListener('message', (event) => {
    const { action, payload } = event.data || {};
    switch (action) {
        case 'open': showApp(); break;
        case 'close': hideApp(); break;
        case 'syncState': applySyncState(payload); break;
        case 'newMessage': appendMessage(payload); break;
        case 'newDeadDrop': appendMessage(payload); break;
        case 'walletUpdate': updateWallet(payload); break;
        default: break;
    }
});

function showApp() {
    qs('#app').classList.remove('hidden');
}

function hideApp() {
    qs('#app').classList.add('hidden');
    closeExifPanel();
}

function applySyncState(payload) {
    if (!payload) return;
    state.channelId = payload.channelId || null;
    state.channelName = payload.channelName || 'OPSEC Kanali';
    state.messages = Array.isArray(payload.messages) ? payload.messages : [];
    state.wallet = payload.wallet || { balance: 0 };

    qs('#channelName').textContent = state.channelName;
    updateWalletDisplay();
    renderMessages();
}

function appendMessage(msg) {
    if (!msg) return;
    state.messages.push(msg);
    renderMessages();
    const list = qs('#messageList');
    list.scrollTop = list.scrollHeight;
}

function updateWallet(payload) {
    if (!payload) return;
    state.wallet.balance = payload.balance;
    updateWalletDisplay();
}

function updateWalletDisplay() {
    qs('#walletBalance').textContent = Number(state.wallet.balance || 0).toFixed(4);
}

// ============ MESAJ LISTESI RENDER ============

function renderMessages() {
    const list = qs('#messageList');
    list.innerHTML = '';
    state.messages.forEach((msg) => list.appendChild(buildMessageNode(msg)));
}

function buildMessageNode(msg) {
    const wrapper = el('div', `message${msg.degraded ? ' degraded' : ''}`);
    wrapper.dataset.msgId = msg.id || '';

    const meta = el('div', 'message-meta');
    meta.appendChild(el('span', 'sender-name', msg.senderName || 'Bilinmeyen Ajan'));
    meta.appendChild(el('span', 'timestamp', formatTimestamp(msg.timestamp)));
    wrapper.appendChild(meta);

    if (msg.type === 'photo') {
        wrapper.appendChild(buildPhotoNode(msg));
    } else {
        wrapper.appendChild(el('div', 'message-text', msg.text || ''));
    }

    wrapper.addEventListener('click', () => markRead(msg.id));
    return wrapper;
}

function buildPhotoNode(msg) {
    const container = el('div', 'photo-message');
    const frame = el('div', 'photo-frame');
    const exif = msg.exif || {};

    // EXIF verileri gizli data-* ozniteliklerinde tutulur; balon uzerinde
    // GORUNMEZ, sadece analiz paneli acildiginda okunur.
    frame.dataset.lat = exif.lat ?? '';
    frame.dataset.lon = exif.lon ?? '';
    frame.dataset.accuracy = exif.accuracyMeters ?? '';
    frame.dataset.device = exif.device ?? '';
    frame.dataset.imei = exif.imei ?? '';
    frame.dataset.capturedAt = exif.capturedAt ?? '';
    frame.dataset.integrity = exif.integrity ?? 'ok';

    frame.appendChild(el('div', 'photo-noise'));

    const overlay = el('div', 'photo-overlay');
    overlay.appendChild(el('span', 'photo-icon', '\u{1F5BC}'));
    overlay.appendChild(el('span', 'photo-label', 'ZULA_TESLIMAT.jpg'));
    overlay.appendChild(el('span', 'photo-sub', 'Tikla / sag-tik: EXIF analiz'));
    frame.appendChild(overlay);

    frame.addEventListener('click', (e) => {
        e.stopPropagation();
        openExifPanel(frame);
    });
    frame.addEventListener('contextmenu', (e) => {
        e.preventDefault();
        e.stopPropagation();
        openExifPanel(frame);
    });

    container.appendChild(frame);
    if (msg.caption) {
        container.appendChild(el('div', 'message-caption', msg.caption));
    }
    return container;
}

function formatTimestamp(unixSeconds) {
    const n = Number(unixSeconds);
    if (!n) return '--:--';
    return new Date(n * 1000).toLocaleString('tr-TR');
}

function markRead(messageId) {
    if (!messageId) return;
    fetchNui('markRead', { messageId });
}

// ============ EXIF / ADLI ANALIZ PANELI ============

function bytesFromString(str) {
    return Array.from(new TextEncoder().encode(str));
}

/** Klasik "hexdump -C" formatinda offset | hex | ascii dokumu uretir. */
function buildHexDump(str) {
    const bytes = bytesFromString(str);
    const lines = [];

    for (let offset = 0; offset < bytes.length; offset += 16) {
        const slice = bytes.slice(offset, offset + 16);
        const hex = slice
            .map((b) => b.toString(16).padStart(2, '0'))
            .join(' ')
            .padEnd(16 * 3 - 1, ' ');
        const ascii = slice
            .map((b) => (b >= 32 && b <= 126 ? String.fromCharCode(b) : '.'))
            .join('');
        lines.push(`${offset.toString(16).padStart(8, '0')}  ${hex}  |${ascii}|`);
    }

    return lines.join('\n');
}

function openExifPanel(frame) {
    const lat = frame.dataset.lat;
    const lon = frame.dataset.lon;
    const accuracy = frame.dataset.accuracy;
    const device = frame.dataset.device;
    const imei = frame.dataset.imei;
    const capturedAt = frame.dataset.capturedAt;
    const integrity = frame.dataset.integrity;

    qs('#exifLat').textContent = lat ? `${lat}°` : 'VERI YOK';
    qs('#exifLon').textContent = lon ? `${lon}°` : 'VERI YOK';
    qs('#exifAccuracy').textContent = accuracy ? `± ${accuracy} m` : 'VERI YOK';
    qs('#exifDevice').textContent = device || 'TANIMSIZ CIHAZ';
    qs('#exifImei').textContent = imei || '---';
    qs('#exifTimestamp').textContent = formatTimestamp(capturedAt);

    const rawPayload = [
        'EXIF/GPS ADLI VERI BLOGU',
        `GPSLatitude=${lat}`,
        `GPSLongitude=${lon}`,
        `GPSAccuracyMeters=${accuracy}`,
        `Model=${device}`,
        `IMEIChecksum=${imei}`,
        `DateTimeOriginal=${capturedAt}`,
        `IntegrityFlag=${integrity}`,
    ].join('\n');

    qs('#exifRawDump').textContent = buildHexDump(rawPayload);

    const warningEl = qs('#exifIntegrityWarning');
    warningEl.classList.toggle('hidden', integrity !== 'suspect');

    qs('#exifPanel').classList.remove('hidden');
}

function closeExifPanel() {
    qs('#exifPanel').classList.add('hidden');
}

// ============ KAPATMA / ESC ============

function closeApp() {
    fetchNui('close', {});
    hideApp();
}

qs('#closeBtn').addEventListener('click', closeApp);
qs('#exifCloseBtn').addEventListener('click', closeExifPanel);

document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;

    if (!qs('#exifPanel').classList.contains('hidden')) {
        closeExifPanel();
    } else if (!qs('#app').classList.contains('hidden')) {
        closeApp();
    }
});
