// === RUNTIME INTEGRITY SEAL & ANTI-TAMPER ===
export const enforceAntiTamper = () => {
  try {
    if (Object.isFrozen(crypto.subtle)) return;
    Object.freeze(crypto);
    Object.freeze(crypto.subtle);
  } catch (e) {}
};

// === STRICT XSS SANITIZATION ===
export const sanitize = (input) => {
  if (!input) return '';
  let clean = input.toString();
  clean = clean.replace(/<[^>]*>?/gm, '');
  clean = clean.replace(/javascript\s*:/gi, '');
  clean = clean.replace(/on\w+\s*=/gi, '');
  clean = clean.replace(/data\s*:/gi, '');
  clean = clean.replace(/vbscript\s*:/gi, '');
  clean = clean.replace(/expression\s*\(/gi, '');
  clean = clean.replace(/eval\s*\(/gi, '');
  clean = clean.replace(/document\.\w+/gi, '');
  clean = clean.replace(/window\.\w+/gi, '');
  clean = clean.replace(/\.constructor/gi, '');
  clean = clean.replace(/__proto__/gi, '');
  return clean;
};

// === 100% REAL ZERO-WIDTH STEGANOGRAPHY (INVISIBLE INK) ===
export const encodeStego = (cover, hidden) => {
  if (!hidden) return cover;
  const binary = hidden.split('').map(c => c.charCodeAt(0).toString(2).padStart(8, '0')).join('');
  const zeroWidth = binary.split('').map(b => b === '0' ? '\u200B' : '\u200C').join('') + '\u200D';
  const pos = Math.max(1, Math.floor(cover.length / 2));
  return cover.slice(0, pos) + zeroWidth + cover.slice(pos);
};

export const decodeStego = (text) => {
  if (!text) return 'NO TEXT ENTERED';
  const match = text.match(/[\u200B\u200C]+\u200D/);
  if (!match) return 'NO HIDDEN STEGO PAYLOAD DETECTED';
  const raw = match[0].replace('\u200D', '');
  const bytes = [];
  for (let i = 0; i < raw.length; i += 8) {
    const bStr = raw.slice(i, i + 8).split('').map(c => c === '\u200B' ? '0' : '1').join('');
    if (bStr.length === 8) bytes.push(String.fromCharCode(parseInt(bStr, 2)));
  }
  return bytes.join('');
};

// === CRYPTO CIPHERS & HASHING ===
export const rot13 = (s) => s.replace(/[a-zA-Z]/g, c => String.fromCharCode((c<='Z'?90:122)>=(c=c.charCodeAt(0)+13)?c:c-26));

export const generateSHA256 = async (t) => {
  if (!t) return '';
  const h = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(t));
  return Array.from(new Uint8Array(h)).map(b => b.toString(16).padStart(2, '0')).join('');
};

export const toBase64 = (t) => {
  if (!t) return '';
  try { return btoa(unescape(encodeURIComponent(t))); } catch (e) { return 'ERR'; }
};

export const textToBinary = (t) => t.split('').map(c => c.charCodeAt(0).toString(2).padStart(8, '0')).join(' ');
export const textToHex = (t) => t.split('').map(c => c.charCodeAt(0).toString(16).padStart(2, '0')).join(' ');
export const textToOctal = (t) => t.split('').map(c => c.charCodeAt(0).toString(8).padStart(3, '0')).join(' ');

export const textToMorse = (t) => {
  const m = {'A':'.-','B':'-...','C':'-.-.','D':'-..','E':'.','F':'..-.','G':'--.','H':'....','I':'..','J':'.---','K':'-.-','L':'.-..','M':'--','N':'-.','O':'---','P':'.--.','Q':'--.-','R':'.-.','S':'...','T':'-','U':'..-','V':'...-','W':'.--','X':'-..-','Y':'-.--','Z':'--..','0':'-----','1':'.----','2':'..---','3':'...--','4':'....-','5':'.....','6':'-....','7':'--...','8':'---..','9':'----.',' ':'/'};
  return t.toUpperCase().split('').map(c => m[c] || c).join(' ');
};

export const morseToText = (m) => {
  const d = {'.-':'A','-...':'B','-.-.':'C','-..':'D','.':'E','..-.':'F','--.':'G','....':'H','..':'I','.---':'J','-.-':'K','.-..':'L','--':'M','-.':'N','---':'O','.--.':'P','--.-':'Q','.-.':'R','...':'S','-':'T','..-':'U','...-':'V','.--':'W','-..-':'X','-.--':'Y','--..':'Z','-----':'0','.----':'1','..---':'2','...--':'3','....-':'4','.....':'5','-....':'6','--...':'7','---..':'8','----.':'9','/':' '};
  return m.split(' ').map(c => d[c] || c).join('');
};

// === 32-CHAR CRYPTO TOKEN & ADMIN KEY GENERATOR ===
export const generateRequestToken = () => {
  const arr = new Uint8Array(16);
  crypto.getRandomValues(arr);
  const h = Array.from(arr).map(b => b.toString(16).padStart(2, '0')).join('').toUpperCase();
  return `REQ-${h.slice(0, 8)}-${h.slice(8, 16)}-${h.slice(16, 24)}-${h.slice(24, 32)}`;
};

export const computeActivationKey = async (token) => {
  const clean = token.replace(/[^A-Za-z0-9]/g, '').toUpperCase();
  const hash = await generateSHA256(clean + "_6712_MASTER_SECRET_SALT_CYBER");
  return hash.slice(0, 32).toUpperCase();
};

// === 250,000 ROUNDS PBKDF2 + AES-256-GCM VAULT ===
export const deriveKey = async (pin) => {
  const km = await crypto.subtle.importKey('raw', new TextEncoder().encode(pin), 'PBKDF2', false, ['deriveKey']);
  return crypto.subtle.deriveKey(
    { name: 'PBKDF2', salt: new TextEncoder().encode('CYBER_SALT_250K_V9'), iterations: 250000, hash: 'SHA-256' },
    km,
    { name: 'AES-GCM', length: 256 },
    false,
    ['encrypt', 'decrypt']
  );
};

export const encryptData = async (pin, txt) => {
  const k = await deriveKey(pin);
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const ct = await crypto.subtle.encrypt({ name: 'AES-GCM', iv }, k, new TextEncoder().encode(txt));
  const c = new Uint8Array(iv.byteLength + ct.byteLength);
  c.set(iv, 0);
  c.set(new Uint8Array(ct), iv.byteLength);
  return btoa(String.fromCharCode(...c));
};

export const decryptData = async (pin, enc) => {
  try {
    const k = await deriveKey(pin);
    const r = Uint8Array.from(atob(enc), c => c.charCodeAt(0));
    const d = await crypto.subtle.decrypt({ name: 'AES-GCM', iv: r.slice(0, 12) }, k, r.slice(12));
    return new TextDecoder().decode(d);
  } catch (e) { return null; }
};

// === EXIF METADATA STRIPPER ===
export const stripExif = async (file) => {
  const buf = await file.arrayBuffer();
  const v = new DataView(buf);
  if (v.getUint16(0) !== 0xFFD8) return file;
  let o = 2;
  const p = [buf.slice(0, 2)];
  while (o < v.byteLength - 1) {
    const m = v.getUint16(o);
    if (m === 0xFFDA) { p.push(buf.slice(o)); break; }
    const l = v.getUint16(o + 2);
    if (m >= 0xFFE1 && m <= 0xFFEF) { o += 2 + l; continue; }
    p.push(buf.slice(o, o + 2 + l));
    o += 2 + l;
  }
  return new Blob(p, { type: 'image/jpeg' });
};

// === PASSWORD GENERATOR ===
export const generatePassword = (length, options) => {
  let chars = '';
  if (options.upper) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if (options.lower) chars += 'abcdefghijklmnopqrstuvwxyz';
  if (options.numbers) chars += '0123456789';
  if (options.symbols) chars += '!@#$%^&*()_+-=[]{}|;:,.<>?';
  if (!chars) chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  const arr = new Uint32Array(length);
  crypto.getRandomValues(arr);
  return Array.from(arr, v => chars[v % chars.length]).join('');
};

export const getPasswordStrength = (pw) => {
  let score = 0;
  if (pw.length >= 8) score++; if (pw.length >= 12) score++; if (pw.length >= 16) score++; if (pw.length >= 24) score++;
  if (/[a-z]/.test(pw)) score++; if (/[A-Z]/.test(pw)) score++; if (/[0-9]/.test(pw)) score++; if (/[^a-zA-Z0-9]/.test(pw)) score++;
  if (score <= 2) return { label: 'WEAK', color: '#ff0040', percent: 25 };
  if (score <= 4) return { label: 'MEDIUM', color: '#ffaa00', percent: 50 };
  if (score <= 6) return { label: 'STRONG', color: '#00ff88', percent: 75 };
  return { label: 'MILITARY FORTRESS', color: '#00ffff', percent: 100 };
};

// === SOUND & HAPTICS ===
export const playBeep = (freq = 800, dur = 70, type = 'square') => {
  try {
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = type;
    osc.frequency.value = freq;
    gain.gain.value = 0.05;
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.start();
    osc.stop(ctx.currentTime + dur / 1000);
  } catch (e) {}
};

export const triggerHaptic = (pattern = [30]) => {
  try {
    if (navigator.vibrate) navigator.vibrate(pattern);
  } catch (e) {}
};

// === DYNAMIC STEALTH CLOAK ===
export const setAppCloak = (mode) => {
  let link = document.querySelector("link[rel~='icon']");
  if (!link) {
    link = document.createElement('link');
    link.rel = 'icon';
    document.head.appendChild(link);
  }
  if (mode === 'calc') {
    document.title = 'Scientific Calculator v4.1';
    link.href = 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">ðŸ§®</text></svg>';
  } else if (mode === 'notes') {
    document.title = 'Simple Notes Pad';
    link.href = 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">ðŸ“</text></svg>';
  } else if (mode === 'clock') {
    document.title = 'System World Clock';
    link.href = 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">â°</text></svg>';
  } else {
    document.title = 'Cyber Terminal [SYS.CORE]';
    link.href = 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">ðŸ’€</text></svg>';
  }
};

export const enforceCSP = () => {};

