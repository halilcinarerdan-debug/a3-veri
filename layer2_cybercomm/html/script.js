/*
    KATMAN 2 | NUI CLIENT
    - Sadece gosterim. Hicbir "gercek" deger burada uretilmez.
    - Memory leak korumasi: MAX_DOM_MESSAGES + event delegation + replaceChildren.
    - Koordinatlar otomatik haritaya islenmez; oyuncu manuel girer.

    Bu surumde 2 doktrinel ek arayuz parcasi bulunur:
      - Crypto-Challenge cubugu (POLICE HONEYPOT tespiti icin)
      - Lockdown overlay (SIGINT MOBILE TRACKER icin)
*/

const state = {
    channelId: null,
    channelName: '',
    messages: [],
    wallet: { balance: 0 },
};

const MAX_DOM_MESSAGES  = 150;   // DOM'da tutulan max balon sayisi
const MAX_STATE_MESSAGES = 500;  // JS state'te tutulan max mesaj (EXIF arama icin)

/* ---------------- UTIL ---------------- */
const qs  = (s) => document.querySelector(s);
const el  = (tag, cls, text) => {
    const n = document.createElement(tag);
    if (cls) n.className = cls;
    if (text !== undefined) n.textContent = text;
    return n;
};
const getResourceName = () =>
    (typeof GetParentResourceName === 'function')
        ? GetParentResourceName()
        : 'layer2_cybercomm';

const fetchNui = (endpoint, data) =>
    fetch(`https://${getResourceName()}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {}),
    }).catch(() => {});

const formatXMR  = (v)  => Number(v || 0).toFixed(4);
const formatTime = (ts) => new Date((ts || 0) * 1000)
    .toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' });
const formatFull = (ts) => new Date((ts || 0) * 1000)
    .toLocaleString('tr-TR');

/* ---------------- DOM REF'LERI ---------------- */
const appRoot         = qs('#app');
const messagesRoot    = qs('#messageList');
const channelNameEl   = qs('#channelName');
const walletBalanceEl = qs('#walletBalance');
const statusTextEl    = qs('#statusText');

const exifPanel       = qs('#exifPanel');
const exifCloseBtn    = qs('#exifCloseBtn');
const exifLat         = qs('#exifLat');
const exifLon         = qs('#exifLon');
const exifAccuracy    = qs('#exifAccuracy');
const exifDevice      = qs('#exifDevice');
const exifImei        = qs('#exifImei');
const exifTimestamp   = qs('#exifTimestamp');
const exifRawDump     = qs('#exifRawDump');
const exifWarning     = qs('#exifIntegrityWarning');

const challengeInput   = qs('#challengeInput');
const challengeSendBtn = qs('#challengeSendBtn');

const lockdownOverlay  = qs('#lockdownOverlay');
const lockdownTimerEl  = qs('#lockdownTimer');

/* ---------------- EVENT DELEGATION (tek listener) ---------------- */
messagesRoot.addEventListener('click', (ev) => {
    const target = ev.target.closest('[data-action]');
    if (!target) return;
    const { action, id } = target.dataset;
    if (action === 'exif')     openExifPanel(id);
    if (action === 'markRead') fetchNui('markRead', { messageId: id });
    if (action === 'claim')    fetchNui('claimDeadDrop', { messageId: id });
});

/* ---------------- RENDER ---------------- */
function buildMessage(msg) {
    const wrap = el('div', 'msg msg-' + (msg.type || 'text'));
    wrap.dataset.id = msg.id;

    const meta = el('div', 'msg-meta');
    meta.appendChild(el('span', 'msg-sender', msg.senderName || msg.senderId || 'Bilinmeyen'));
    meta.appendChild(el('span', 'msg-time',   formatTime(msg.timestamp)));
    wrap.appendChild(meta);

    if (msg.type === 'photo') {
        const body = el('div', 'msg-body');
        body.appendChild(el('p', 'msg-caption', msg.caption || '[fotograf]'));

        const exifBtn = el('button', 'exif-btn', 'EXIF Analiz Et');
        exifBtn.dataset.action = 'exif';
        exifBtn.dataset.id     = msg.id;
        body.appendChild(exifBtn);

        if (msg.claimed) {
            body.appendChild(el('div', 'claimed-badge', 'TESLIM ALINDI'));
        } else {
            const claimBtn = el('button', 'claim-btn', 'Zulayi Teslim Al');
            claimBtn.dataset.action = 'claim';
            claimBtn.dataset.id     = msg.id;
            body.appendChild(claimBtn);
        }
        wrap.appendChild(body);
    } else {
        wrap.appendChild(el('p', 'msg-text', msg.text || ''));
    }
    return wrap;
}

function trimDom() {
    while (messagesRoot.children.length > MAX_DOM_MESSAGES) {
        messagesRoot.removeChild(messagesRoot.firstChild);
    }
}

function renderAllMessages(list) {
    // replaceChildren: alt agaclari tek seferde sifirlar (GC dostu)
    messagesRoot.replaceChildren();
    const slice = list.slice(-MAX_DOM_MESSAGES);
    const frag  = document.createDocumentFragment();
    for (const m of slice) frag.appendChild(buildMessage(m));
    messagesRoot.appendChild(frag);
    messagesRoot.scrollTop = messagesRoot.scrollHeight;
}

function appendMessage(msg) {
    messagesRoot.appendChild(buildMessage(msg));
    trimDom();
    messagesRoot.scrollTop = messagesRoot.scrollHeight;

    state.messages.push(msg);
    if (state.messages.length > MAX_STATE_MESSAGES) {
        state.messages.splice(0, state.messages.length - MAX_STATE_MESSAGES);
    }
}

/* ---------------- EXIF PANEL ---------------- */
function openExifPanel(messageId) {
    const msg = state.messages.find(m => m.id === messageId);
    if (!msg || !msg.exif) return;
    const e = msg.exif;

    exifLat.textContent       = Number(e.latitude  || 0).toFixed(6);
    exifLon.textContent       = Number(e.longitude || 0).toFixed(6);
    exifAccuracy.textContent  = (e.accuracy || 0) + ' m';
    exifDevice.textContent    = e.device || 'Bilinmiyor';
    exifImei.textContent      = e.imei   || 'N/A';
    exifTimestamp.textContent = formatFull(e.timestamp);
    exifRawDump.textContent   = e.rawDump || '--';

    exifWarning.classList.toggle('hidden', !e.integrityWarning);
    exifPanel.classList.remove('hidden');
}

function closeExifPanel() { exifPanel.classList.add('hidden'); }
exifCloseBtn.addEventListener('click', closeExifPanel);

/* ---------------- WALLET ---------------- */
function updateWallet(balance) {
    state.wallet.balance   = Number(balance) || 0;
    walletBalanceEl.textContent = formatXMR(state.wallet.balance);
}

/* ---------------- CRYPTO-CHALLENGE ----------------
   Oyuncunun mevcut kanaldaki EN SON gonderen ajana gizli bir guvenlik
   ifadesi (parola) gondermesini saglar. Dogru/yanlis diye bir sistem
   gostergesi YOKTUR; ajanin verdigi cevap normal bir mesaj olarak
   dusecek, oyuncu bunu OKUYARAK degerlendirecektir (arcade degil).
------------------------------------------------------ */
function getActiveAgentId() {
    for (let i = state.messages.length - 1; i >= 0; i--) {
        if (state.messages[i].senderId) return state.messages[i].senderId;
    }
    return null;
}

function sendChallenge() {
    const phrase  = challengeInput.value.trim();
    const agentId = getActiveAgentId();
    if (!phrase || !agentId) return;

    fetchNui('sendChallenge', { agentId, phrase });
    challengeInput.value = '';
}

challengeSendBtn.addEventListener('click', sendChallenge);
challengeInput.addEventListener('keydown', (ev) => {
    if (ev.key === 'Enter') sendChallenge();
});

/* ---------------- LOCKDOWN OVERLAY (SIGINT) ---------------- */
let lockdownIntervalId = null;

function formatLockdownTimer(totalSeconds) {
    const m = String(Math.floor(totalSeconds / 60)).padStart(2, '0');
    const s = String(totalSeconds % 60).padStart(2, '0');
    return `${m}:${s}`;
}

function startLockdown(seconds) {
    clearInterval(lockdownIntervalId);
    let remaining = Math.max(0, Math.floor(Number(seconds) || 0));

    lockdownOverlay.classList.remove('hidden');
    lockdownTimerEl.textContent = formatLockdownTimer(remaining);

    lockdownIntervalId = setInterval(() => {
        remaining = Math.max(0, remaining - 1);
        lockdownTimerEl.textContent = formatLockdownTimer(remaining);
        if (remaining <= 0) clearInterval(lockdownIntervalId);
    }, 1000);
}

function endLockdown() {
    clearInterval(lockdownIntervalId);
    lockdownOverlay.classList.add('hidden');
}

/* ---------------- NUI ROUTER ---------------- */
window.addEventListener('message', (ev) => {
    const { action, data } = ev.data || {};
    switch (action) {
        case 'open':
            appRoot.classList.remove('hidden');
            exifPanel.classList.add('hidden');
            break;

        case 'close':
            appRoot.classList.add('hidden');
            exifPanel.classList.add('hidden');
            break;

        case 'syncState':
            state.channelId   = data.channelId;
            state.channelName = data.channelName || 'OPSEC';
            channelNameEl.textContent = state.channelName;
            state.messages    = Array.isArray(data.messages) ? data.messages : [];
            renderAllMessages(state.messages);
            if (data.wallet) updateWallet(data.wallet.balance);
            break;

        case 'newMessage':
        case 'newDeadDrop':
            appendMessage(data);
            break;

        case 'walletUpdate':
            updateWallet(data.balance);
            break;

        case 'notify':
            if (statusTextEl && data && typeof data.message === 'string') {
                statusTextEl.textContent = data.message;
            }
            break;

        case 'lockdown':
            if (data && data.active) {
                startLockdown(data.seconds);
            } else {
                endLockdown();
            }
            break;
    }
});

/* ---------------- KAPATMA ---------------- */
qs('#closeBtn').addEventListener('click', () => fetchNui('close'));

document.addEventListener('keydown', (ev) => {
    if (ev.key !== 'Escape') return;
    if (!exifPanel.classList.contains('hidden')) { closeExifPanel(); return; }
    fetchNui('close');
});

/* ---------------- UNLOAD TEMIZLIGI ---------------- */
window.addEventListener('beforeunload', () => {
    messagesRoot.replaceChildren();
    state.messages = [];
    clearInterval(lockdownIntervalId);
});
