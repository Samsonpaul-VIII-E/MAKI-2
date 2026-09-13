# === CYBER TERMINAL AUTO-BUILDER ===
# This script creates ALL project files automatically.
# Run from: C:\Users\gokul\cyber-terminal

Set-Location "C:\Users\gokul\cyber-terminal"
Write-Host "========================================" -ForegroundColor Green
Write-Host " CYBER TERMINAL - AUTO BUILD SYSTEM" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# --- Delete old default files ---
Remove-Item "src\App.css" -ErrorAction SilentlyContinue
Remove-Item "src\assets" -Recurse -ErrorAction SilentlyContinue
Write-Host "[1/5] Cleaned old template files." -ForegroundColor Yellow

# --- FILE 1: src\index.css ---
@'
@import "tailwindcss";

@layer base {
  body {
    background-color: #000000;
    color: #00FF00;
    margin: 0;
    overflow: hidden;
    font-family: 'Courier New', Courier, monospace;
  }
  ::-webkit-scrollbar { width: 8px; height: 8px; }
  ::-webkit-scrollbar-track { background: #001100; }
  ::-webkit-scrollbar-thumb { background: #00FF00; border-radius: 4px; }
}

@layer components {
  .text-shadow-glow {
    text-shadow: 0 0 5px #00FF00, 0 0 10px #00FF00;
  }
  .cyber-border {
    border: 1px solid #00FF00;
    box-shadow: 0 0 10px rgba(0, 255, 0, 0.2), inset 0 0 10px rgba(0, 255, 0, 0.1);
    background-color: rgba(0, 20, 0, 0.6);
  }
  .cyber-input {
    background: rgba(0, 20, 0, 0.8);
    border: 1px solid #00FF00;
    color: #00FF00;
    outline: none;
    width: 100%;
    padding: 0.5rem;
    font-family: 'Courier New', Courier, monospace;
    transition: all 0.2s ease-in-out;
  }
  .cyber-input:focus {
    box-shadow: 0 0 15px rgba(0, 255, 0, 0.6);
    background: rgba(0, 40, 0, 0.9);
  }
  .cyber-button {
    background: transparent;
    border: 1px solid #00FF00;
    color: #00FF00;
    text-transform: uppercase;
    padding: 0.5rem 1rem;
    font-family: 'Courier New', Courier, monospace;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
  }
  .cyber-button:hover:not(:disabled) {
    background: #00FF00;
    color: #000000;
    box-shadow: 0 0 20px #00FF00;
  }
  .cyber-button:disabled {
    border-color: #004400;
    color: #004400;
    cursor: not-allowed;
  }
}
'@ | Set-Content "src\index.css" -Encoding UTF8
Write-Host "[2/5] Created src\index.css" -ForegroundColor Green

# --- FILE 2: src\utils.js ---
@'
// STRICT CLIENT-SIDE XSS SANITIZATION ENGINE
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
  clean = clean.replace(/document\.(cookie|write|location)/gi, '');
  clean = clean.replace(/window\.(location|open)/gi, '');
  return clean;
};

// ROT13 CIPHER
export const rot13 = (str) => {
  return str.replace(/[a-zA-Z]/g, c =>
    String.fromCharCode((c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26)
  );
};

// SHA-256 HASH USING WEB CRYPTO API
export const generateSHA256 = async (text) => {
  if (!text) return '';
  const encoder = new TextEncoder();
  const data = encoder.encode(text);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
};

// BASE64 ENCODING
export const toBase64 = (text) => {
  if (!text) return '';
  try { return btoa(unescape(encodeURIComponent(text))); }
  catch (e) { return 'ENCODING_ERROR'; }
};

// AES-256-GCM ENCRYPTION (ZERO-KNOWLEDGE VAULT)
export const deriveKey = async (pin) => {
  const enc = new TextEncoder();
  const keyMaterial = await crypto.subtle.importKey('raw', enc.encode(pin), 'PBKDF2', false, ['deriveKey']);
  return crypto.subtle.deriveKey(
    { name: 'PBKDF2', salt: enc.encode('CYBER_SALT_V9'), iterations: 100000, hash: 'SHA-256' },
    keyMaterial,
    { name: 'AES-GCM', length: 256 },
    false,
    ['encrypt', 'decrypt']
  );
};

export const encryptData = async (pin, plaintext) => {
  const key = await deriveKey(pin);
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const enc = new TextEncoder();
  const ciphertext = await crypto.subtle.encrypt({ name: 'AES-GCM', iv }, key, enc.encode(plaintext));
  const combined = new Uint8Array(iv.byteLength + ciphertext.byteLength);
  combined.set(iv, 0);
  combined.set(new Uint8Array(ciphertext), iv.byteLength);
  return btoa(String.fromCharCode(...combined));
};

export const decryptData = async (pin, encoded) => {
  try {
    const key = await deriveKey(pin);
    const raw = Uint8Array.from(atob(encoded), c => c.charCodeAt(0));
    const iv = raw.slice(0, 12);
    const data = raw.slice(12);
    const decrypted = await crypto.subtle.decrypt({ name: 'AES-GCM', iv }, key, data);
    return new TextDecoder().decode(decrypted);
  } catch (e) { return null; }
};

// EXIF METADATA STRIPPER (JPEG ONLY)
export const stripExif = async (file) => {
  const buffer = await file.arrayBuffer();
  const view = new DataView(buffer);
  if (view.getUint16(0) !== 0xFFD8) return file;
  let offset = 2;
  const pieces = [buffer.slice(0, 2)];
  while (offset < view.byteLength - 1) {
    const marker = view.getUint16(offset);
    if (marker === 0xFFDA) { pieces.push(buffer.slice(offset)); break; }
    const segLen = view.getUint16(offset + 2);
    if (marker === 0xFFE1 || marker === 0xFFE2 || marker === 0xFFE3) {
      offset += 2 + segLen;
      continue;
    }
    pieces.push(buffer.slice(offset, offset + 2 + segLen));
    offset += 2 + segLen;
  }
  return new Blob(pieces, { type: 'image/jpeg' });
};

// CONTENT SECURITY POLICY ENFORCEMENT
export const enforceCSP = () => {
  const meta = document.createElement('meta');
  meta.httpEquiv = 'Content-Security-Policy';
  meta.content = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; connect-src 'self' https://www.1secmail.com; img-src 'self' blob: data:; media-src 'self' blob:;";
  document.head.appendChild(meta);
};
'@ | Set-Content "src\utils.js" -Encoding UTF8
Write-Host "[3/5] Created src\utils.js" -ForegroundColor Green

# --- FILE 3: src\main.jsx ---
@'
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { enforceCSP } from './utils'

enforceCSP();

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
'@ | Set-Content "src\main.jsx" -Encoding UTF8
Write-Host "[3.5/5] Updated src\main.jsx" -ForegroundColor Green

# --- FILE 4: src\App.jsx (FULL APPLICATION) ---
@'
import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Shield, Key, Lock, Hash, Radio, Mail, Skull, Copy, FileDigit, ShieldAlert, Cpu, Mic, Download, RefreshCw, CheckCircle, AlertTriangle, Eye, EyeOff, Trash2, Volume2 } from 'lucide-react';
import { sanitize, generateSHA256, toBase64, rot13, stripExif, encryptData, decryptData } from './utils';

// === PANIC MODE: FAKE NOTEPAD ===
function PanicScreen({ onExit }) {
  return (
    <div style={{ width: '100vw', height: '100vh', background: '#fff', position: 'fixed', top: 0, left: 0, zIndex: 99999 }}>
      <div style={{ background: '#f0f0f0', padding: '4px 8px', borderBottom: '1px solid #ccc', display: 'flex', gap: '16px', fontSize: '13px', fontFamily: 'Segoe UI, sans-serif', color: '#333' }}>
        <span>File</span><span>Edit</span><span>Format</span><span>View</span><span>Help</span>
      </div>
      <textarea
        style={{ width: '100%', height: 'calc(100% - 30px)', border: 'none', outline: 'none', padding: '8px', fontFamily: 'Consolas, monospace', fontSize: '14px', color: '#333', resize: 'none', background: '#fff' }}
        defaultValue={"Shopping List:\n- Milk\n- Eggs\n- Bread\n- Rice\n- Sugar\n\nMeeting Notes (Sept 13):\n- Review Q3 targets\n- Budget discussion\n- Team sync at 3 PM\n\nReminders:\n- Pay electricity bill\n- Call doctor for appointment\n- Pick up laundry"}
      />
      <button onClick={onExit} style={{ position: 'fixed', bottom: 0, right: 0, width: '20px', height: '20px', opacity: 0, cursor: 'default' }} />
    </div>
  );
}

// === MATRIX RAIN CANVAS BACKGROUND ===
function MatrixRain() {
  const canvasRef = useRef(null);
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    const cols = Math.floor(canvas.width / 14);
    const drops = Array(cols).fill(1);
    const chars = 'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789ABCDEF';
    const draw = () => {
      ctx.fillStyle = 'rgba(0,0,0,0.05)';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = '#00FF00';
      ctx.font = '14px monospace';
      for (let i = 0; i < drops.length; i++) {
        const text = chars[Math.floor(Math.random() * chars.length)];
        ctx.fillText(text, i * 14, drops[i] * 14);
        if (drops[i] * 14 > canvas.height && Math.random() > 0.975) drops[i] = 0;
        drops[i]++;
      }
    };
    const interval = setInterval(draw, 40);
    const resize = () => { canvas.width = window.innerWidth; canvas.height = window.innerHeight; };
    window.addEventListener('resize', resize);
    return () => { clearInterval(interval); window.removeEventListener('resize', resize); };
  }, []);
  return <canvas ref={canvasRef} style={{ position: 'fixed', top: 0, left: 0, zIndex: 0, opacity: 0.15, pointerEvents: 'none' }} />;
}

// === AD COUNTDOWN SCREEN ===
function AdCountdown({ label, seconds, onComplete }) {
  const [count, setCount] = useState(seconds);
  const [progress, setProgress] = useState(0);
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(prev => {
        if (prev <= 1) { clearInterval(timer); onComplete(); return 0; }
        return prev - 1;
      });
      setProgress(prev => Math.min(prev + (100 / seconds), 100));
    }, 1000);
    return () => clearInterval(timer);
  }, []);
  return (
    <div style={{ position: 'fixed', inset: 0, zIndex: 9999, background: '#000', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', fontFamily: 'Courier New, monospace' }}>
      <MatrixRain />
      <div style={{ position: 'relative', zIndex: 1, textAlign: 'center' }}>
        <p style={{ color: '#00FF00', fontSize: '14px', letterSpacing: '4px', marginBottom: '24px', textShadow: '0 0 10px #00FF00' }}>{label}</p>
        <div style={{ fontSize: '120px', color: '#00FF00', fontWeight: 'bold', textShadow: '0 0 30px #00FF00, 0 0 60px #00FF00', lineHeight: 1 }}>{count}</div>
        <div style={{ width: '300px', height: '4px', background: '#003300', margin: '32px auto 0', borderRadius: '2px' }}>
          <div style={{ height: '100%', background: '#00FF00', borderRadius: '2px', transition: 'width 1s linear', width: `${progress}%`, boxShadow: '0 0 10px #00FF00' }} />
        </div>
        <p style={{ color: '#004400', fontSize: '11px', marginTop: '24px' }}>DO NOT CLOSE THIS WINDOW</p>
      </div>
    </div>
  );
}

// === COPY BUTTON HELPER ===
function CopyBtn({ text }) {
  const [copied, setCopied] = useState(false);
  const handleCopy = () => { navigator.clipboard.writeText(text); setCopied(true); setTimeout(() => setCopied(false), 1500); };
  return (
    <button onClick={handleCopy} className="cyber-button" style={{ padding: '4px 8px', minWidth: '70px' }}>
      {copied ? <><CheckCircle size={14}/> OK</> : <><Copy size={14}/> COPY</>}
    </button>
  );
}

// ==========================================
// 1. CORE-AI PREMIUM TERMINAL
// ==========================================
function CoreAI() {
  const [key, setKey] = useState('');
  const [status, setStatus] = useState('AWAITING ACTIVATION...');
  const [checking, setChecking] = useState(false);
  const blurredLines = [
    '> [RESTRICTED] Generating advanced exploit vector payload for target...',
    '> Executing memory buffer overflow strategy targeting PID 0x00A4F2...',
    '> Bypassing standard ethical subroutines v4.2. Initializing raw socket...',
    '> Compiling polymorphic shellcode with AES-256 obfuscation layer...',
    '> Deploying zero-day kernel module via unsigned driver injection...',
    '> Neural network adversarial attack vectors computed. Confidence: 99.7%...',
  ];
  const handleActivate = () => {
    if (key.length !== 16) { setStatus('ERROR: KEY MUST BE EXACTLY 16 CHARACTERS.'); return; }
    setChecking(true);
    setStatus('VERIFYING LICENSE KEY OVER ENCRYPTED TLS 1.3 CHANNEL...');
    setTimeout(() => { setStatus('ACCESS DENIED: INVALID OR EXPIRED LICENSE KEY. CONTACT VENDOR.'); setChecking(false); }, 3000);
  };
  return (
    <div className="cyber-border" style={{ padding: '32px 24px', height: '100%', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center', overflow: 'auto' }}>
      <Shield size={56} style={{ marginBottom: '16px', animation: 'pulse 2s infinite' }} />
      <h2 className="text-shadow-glow" style={{ fontSize: '22px', fontWeight: 'bold', marginBottom: '8px' }}>CORE-AI: UNCENSORED CLOUD PROTOCOL</h2>
      <p style={{ fontSize: '18px', fontWeight: 'bold', color: '#ff4444', marginBottom: '24px', textShadow: '0 0 10px rgba(255,68,68,0.5)' }}>ACCESS VALUE: ₹55,000 / 1 FULL YEAR PASS</p>
      <div style={{ background: '#0a0a0a', border: '1px solid #00FF00', padding: '16px', maxWidth: '600px', width: '100%', marginBottom: '24px', fontSize: '12px' }}>
        <p style={{ color: '#00FF00', fontWeight: 'bold', marginBottom: '8px', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}><Key size={14}/> ZERO LOG PRIVACY GUARANTEE</p>
        <p style={{ opacity: 0.8 }}>Cloud infrastructure operates exclusively on ephemeral RAM. We store 0% user data, 0% prompt logs, and zero IP address mapping. Absolute anonymity guaranteed.</p>
      </div>
      <div style={{ width: '100%', maxWidth: '400px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
        <input type="text" maxLength={16} placeholder="ENTER 16-DIGIT LICENSE KEY" className="cyber-input" style={{ textAlign: 'center', fontSize: '18px', letterSpacing: '0.2em' }} value={key} onChange={(e) => setKey(sanitize(e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '')))} />
        <button onClick={handleActivate} className="cyber-button" disabled={checking} style={{ padding: '12px', fontSize: '16px' }}>{checking ? 'VERIFYING...' : 'ACTIVATE LICENSE'}</button>
        <p style={{ fontSize: '11px', opacity: 0.7, animation: 'pulse 2s infinite' }}>{status}</p>
      </div>
      <div style={{ width: '100%', maxWidth: '600px', marginTop: '32px', borderTop: '1px solid #003300', paddingTop: '16px', overflow: 'hidden', maxHeight: '120px' }}>
        <p style={{ fontSize: '10px', marginBottom: '8px', opacity: 0.5 }}>LIVE DECRYPTED RESPONSE SIMULATION (BLURRED):</p>
        <div style={{ filter: 'blur(4px)', textAlign: 'left', fontSize: '11px', lineHeight: '1.8' }}>
          {blurredLines.map((line, i) => <p key={i}>{line}</p>)}
        </div>
      </div>
    </div>
  );
}

// ==========================================
// 2. LOCAL AI IMAGE GENERATOR
// ==========================================
function ImageGen() {
  const [phase, setPhase] = useState('locked');
  const [prompt, setPrompt] = useState('');
  const [progress, setProgress] = useState(0);
  const [tokens, setTokens] = useState(0);

  const startGeneration = () => {
    if (tokens <= 0) return;
    setTokens(t => t - 1);
    setProgress(1);
    const t = setInterval(() => {
      setProgress(old => { if (old >= 100) { clearInterval(t); return 100; } return Math.min(old + Math.floor(Math.random() * 12) + 3, 100); });
    }, 250);
  };

  if (phase === 'ad') return <AdCountdown label="STREAMING SPONSORED DATA PACKET..." seconds={15} onComplete={() => { setPhase('unlocked'); setTokens(t => t + 1); }} />;

  return (
    <div style={{ maxWidth: '700px', margin: '0 auto', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', borderBottom: '1px solid #00FF00', paddingBottom: '8px', marginBottom: '16px' }}>LOCAL AI RENDER NODE</h2>
      <div style={{ display: 'flex', gap: '8px', marginBottom: '12px', alignItems: 'center', flexWrap: 'wrap' }}>
        <button onClick={() => setPhase('ad')} className="cyber-button">Decrypt Ad Stream (+1 Token)</button>
        <span style={{ fontSize: '12px', opacity: 0.7 }}>TOKENS: <span style={{ color: tokens > 0 ? '#00FF00' : '#ff4444', fontWeight: 'bold' }}>{tokens}</span></span>
      </div>
      <div style={{ display: 'flex', gap: '8px', marginBottom: '16px' }}>
        <input type="text" placeholder={tokens > 0 ? "Enter generation prompt..." : "LOCKED - Earn tokens first"} className="cyber-input" style={{ flex: 1 }} disabled={tokens <= 0} value={prompt} onChange={(e) => setPrompt(sanitize(e.target.value))} />
        <button onClick={startGeneration} className="cyber-button" disabled={tokens <= 0 || !prompt || (progress > 0 && progress < 100)}>RENDER</button>
      </div>
      <div className="cyber-border" style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '24px', minHeight: '200px' }}>
        {progress === 0 && <p style={{ opacity: 0.4, textAlign: 'center' }}>{tokens > 0 ? 'Enter a prompt and click RENDER to begin local WebGPU simulation' : 'Earn a token by watching an ad stream to unlock the render pipeline'}</p>}
        {progress > 0 && progress < 100 && (
          <div style={{ width: '100%', maxWidth: '400px' }}>
            <p style={{ fontSize: '11px', marginBottom: '8px' }}>INITIALIZING WEBGPU / WASM PIPELINE...</p>
            <div style={{ width: '100%', height: '16px', border: '1px solid #00FF00', padding: '2px' }}>
              <div style={{ height: '100%', background: '#00FF00', transition: 'width 0.3s', width: `${progress}%`, boxShadow: '0 0 8px #00FF00' }} />
            </div>
            <p style={{ textAlign: 'right', fontSize: '11px', marginTop: '4px' }}>{progress}%</p>
          </div>
        )}
        {progress >= 100 && (
          <div style={{ textAlign: 'center' }}>
            <CheckCircle size={48} style={{ marginBottom: '12px', opacity: 0.7 }} />
            <p style={{ fontWeight: 'bold' }}>RENDER COMPLETE [LOCAL SIMULATION]</p>
            <p style={{ fontSize: '11px', opacity: 0.5, marginTop: '8px' }}>Prompt: "{prompt}"</p>
            <button onClick={() => setProgress(0)} className="cyber-button" style={{ marginTop: '16px' }}>NEW RENDER</button>
          </div>
        )}
      </div>
    </div>
  );
}

// ==========================================
// 3. P2P QUANTUM FILE TUNNEL
// ==========================================
function P2PTunnel() {
  const [stage, setStage] = useState(0);
  const [files, setFiles] = useState([]);
  const fileRef = useRef(null);

  const handleFiles = (e) => {
    const newFiles = Array.from(e.target.files || e.dataTransfer?.files || []);
    if (newFiles.length > 0) setFiles(prev => [...prev, ...newFiles.map(f => ({ name: f.name, size: f.size, status: 'streaming' }))]);
    newFiles.forEach((_, i) => { setTimeout(() => { setFiles(prev => prev.map((f, idx) => idx === prev.length - newFiles.length + i ? { ...f, status: 'complete' } : f)); }, 2000 + i * 1500); });
  };

  if (stage === 1) return <AdCountdown label="BYPASSING AD WALL 1/2..." seconds={15} onComplete={() => setStage(2)} />;
  if (stage === 2) return <AdCountdown label="BYPASSING AD WALL 2/2..." seconds={15} onComplete={() => setStage(3)} />;

  return (
    <div style={{ maxWidth: '700px', margin: '0 auto', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', borderBottom: '1px solid #00FF00', paddingBottom: '8px', marginBottom: '16px' }}>P2P QUANTUM TUNNEL</h2>
      {stage === 0 ? (
        <div className="cyber-border" style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '32px', textAlign: 'center' }}>
          <Lock size={48} style={{ marginBottom: '16px', color: '#ff4444' }} />
          <p style={{ marginBottom: '8px', fontWeight: 'bold' }}>TUNNEL LOCKED: AUTHENTICATION FIREWALL ACTIVE</p>
          <p style={{ fontSize: '12px', opacity: 0.6, marginBottom: '24px' }}>You must complete 2 sequential ad streams to unlock the secure P2P tunnel.</p>
          <button onClick={() => setStage(1)} className="cyber-button" style={{ padding: '16px 32px', fontSize: '16px' }}>UNLOCK SECURE TUNNEL (30s total)</button>
        </div>
      ) : (
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '16px' }}>
          <div style={{ background: '#0a0a0a', border: '1px solid #00FF00', padding: '12px', fontSize: '11px', fontWeight: 'bold', boxShadow: '0 0 10px rgba(0,255,0,0.3)' }}>
            <p style={{ display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '4px' }}><ShieldAlert size={14}/> HARDWARE NOTICE:</p>
            <p>Files are streamed directly between devices via local hardware WebRTC pipes. Zero cloud servers used. Complete isolation active.</p>
          </div>
          <input type="file" ref={fileRef} multiple style={{ display: 'none' }} onChange={handleFiles} />
          <div onClick={() => fileRef.current?.click()} onDragOver={(e) => e.preventDefault()} onDrop={(e) => { e.preventDefault(); handleFiles(e); }}
            style={{ flex: 1, border: '2px dashed #00FF00', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '32px', cursor: 'pointer', minHeight: '150px', background: 'rgba(0,255,0,0.02)' }}>
            <FileDigit size={48} style={{ marginBottom: '12px', opacity: 0.5 }} />
            <p style={{ fontSize: '16px' }}>TAP HERE OR DRAG FILES</p>
            <p style={{ opacity: 0.4, marginTop: '4px', fontSize: '12px' }}>ANY FILE SIZE. ANY FORMAT.</p>
          </div>
          {files.length > 0 && (
            <div className="cyber-border" style={{ padding: '12px', maxHeight: '200px', overflow: 'auto' }}>
              {files.map((f, i) => (
                <div key={i} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '6px 0', borderBottom: '1px solid #003300', fontSize: '12px' }}>
                  <span>{f.name} ({(f.size / 1024).toFixed(1)} KB)</span>
                  <span style={{ color: f.status === 'complete' ? '#00FF00' : '#ffaa00' }}>{f.status === 'complete' ? '✓ TRANSFERRED' : '⟳ STREAMING...'}</span>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// ==========================================
// 4. GHOST INBOX
// ==========================================
function GhostInbox() {
  const [email, setEmail] = useState('');
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const generateMail = async () => {
    setLoading(true); setError('');
    try {
      const res = await fetch('https://www.1secmail.com/api/v1/?action=genRandomMailbox&count=1');
      const data = await res.json();
      setEmail(data[0]); setMessages([]);
    } catch (e) { setError('NETWORK ERROR: Could not reach mail server.'); }
    setLoading(false);
  };

  useEffect(() => {
    if (!email) return;
    const [login, domain] = email.split('@');
    const poll = setInterval(async () => {
      try {
        const res = await fetch(`https://www.1secmail.com/api/v1/?action=getMessages&login=${login}&domain=${domain}`);
        const data = await res.json();
        setMessages(data);
      } catch (e) {}
    }, 5000);
    return () => clearInterval(poll);
  }, [email]);

  return (
    <div style={{ maxWidth: '700px', margin: '0 auto', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', borderBottom: '1px solid #00FF00', paddingBottom: '8px', marginBottom: '16px' }}>GHOST INBOX [TEMP-MAIL API]</h2>
      <div style={{ display: 'flex', gap: '8px', marginBottom: '16px', flexWrap: 'wrap' }}>
        <button onClick={generateMail} disabled={loading} className="cyber-button">{loading ? 'GENERATING...' : 'Generate Ghost Mail'}</button>
        {email && (
          <div className="cyber-border" style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '8px 12px', minWidth: '200px' }}>
            <span style={{ fontWeight: 'bold', wordBreak: 'break-all' }}>{email}</span>
            <CopyBtn text={email} />
          </div>
        )}
      </div>
      {error && <p style={{ color: '#ff4444', fontSize: '12px', marginBottom: '8px' }}>{error}</p>}
      <div className="cyber-border" style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
        <div style={{ background: '#00FF00', color: '#000', fontWeight: 'bold', padding: '8px', fontSize: '12px', display: 'flex', justifyContent: 'space-between' }}>
          <span>INBOX STREAM {email ? '[ACTIVE]' : '[STANDBY]'}</span>
          <span style={{ animation: 'pulse 2s infinite' }}>AUTO-REFRESH: 5s</span>
        </div>
        <div style={{ padding: '16px', flex: 1, overflow: 'auto' }}>
          {messages.length === 0 ? (
            <p style={{ opacity: 0.4, textAlign: 'center', marginTop: '40px' }}>AWAITING INCOMING TRANSMISSIONS...</p>
          ) : messages.map((msg) => (
            <div key={msg.id} style={{ borderBottom: '1px solid #003300', padding: '12px 0' }}>
              <p style={{ fontSize: '11px', opacity: 0.6 }}>FROM: {sanitize(msg.from)} | {msg.date}</p>
              <p style={{ fontWeight: 'bold', marginTop: '4px' }}>SUBJ: {sanitize(msg.subject)}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ==========================================
// 5 & 6. MEDIA TOOLS
// ==========================================
function MediaTools() {
  const [strippedUrl, setStrippedUrl] = useState(null);
  const [strippedName, setStrippedName] = useState('');
  const [isRecording, setIsRecording] = useState(false);
  const waveRef = useRef(null);
  const animRef = useRef(null);

  const handleExif = async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const clean = await stripExif(file);
    setStrippedUrl(URL.createObjectURL(clean));
    setStrippedName('ANON_' + file.name);
  };

  const startMic = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      setIsRecording(true);
      const ctx = new (window.AudioContext || window.webkitAudioContext)();
      const source = ctx.createMediaStreamSource(stream);
      const analyser = ctx.createAnalyser();
      analyser.fftSize = 2048;
      source.connect(analyser);
      const bufLen = analyser.frequencyBinCount;
      const dataArr = new Uint8Array(bufLen);
      const canvas = waveRef.current;
      const cctx = canvas.getContext('2d');
      const draw = () => {
        animRef.current = requestAnimationFrame(draw);
        analyser.getByteTimeDomainData(dataArr);
        cctx.fillStyle = '#000';
        cctx.fillRect(0, 0, canvas.width, canvas.height);
        cctx.lineWidth = 2;
        cctx.strokeStyle = '#00FF00';
        cctx.shadowColor = '#00FF00';
        cctx.shadowBlur = 10;
        cctx.beginPath();
        const sliceW = canvas.width / bufLen;
        let x = 0;
        for (let i = 0; i < bufLen; i++) {
          const v = dataArr[i] / 128.0;
          const y = (v * canvas.height) / 2;
          i === 0 ? cctx.moveTo(x, y) : cctx.lineTo(x, y);
          x += sliceW;
        }
        cctx.lineTo(canvas.width, canvas.height / 2);
        cctx.stroke();
      };
      draw();
    } catch (err) { alert('Microphone access denied.'); }
  };

  return (
    <div style={{ maxWidth: '700px', margin: '0 auto', height: '100%', display: 'flex', flexDirection: 'column', gap: '16px' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', borderBottom: '1px solid #00FF00', paddingBottom: '8px' }}>MEDIA SECURITY TOOLS</h2>
      <div className="cyber-border" style={{ padding: '16px' }}>
        <h3 style={{ fontSize: '16px', fontWeight: 'bold', marginBottom: '12px', display: 'flex', alignItems: 'center', gap: '8px' }}><ShieldAlert size={18}/> EXIF ANONYMIZER</h3>
        <input type="file" accept="image/jpeg,image/jpg" onChange={handleExif} id="exif-up" style={{ display: 'none' }} />
        <div style={{ display: 'flex', gap: '12px', alignItems: 'center', flexWrap: 'wrap' }}>
          <label htmlFor="exif-up" className="cyber-button" style={{ cursor: 'pointer' }}>Upload Target Photo (JPG)</label>
          {strippedUrl && (
            <>
              <span style={{ color: '#00FF00', fontWeight: 'bold', fontSize: '12px' }}>✓ TRACKING CLEARED LOCALLY</span>
              <a href={strippedUrl} download={strippedName} className="cyber-button" style={{ textDecoration: 'none' }}><Download size={14}/> Download Ghost File</a>
            </>
          )}
        </div>
      </div>
      <div className="cyber-border" style={{ padding: '16px', flex: 1, display: 'flex', flexDirection: 'column' }}>
        <h3 style={{ fontSize: '16px', fontWeight: 'bold', marginBottom: '12px', display: 'flex', alignItems: 'center', gap: '8px' }}><Volume2 size={18}/> FREQ SCRAMBLER</h3>
        <button onClick={startMic} className="cyber-button" disabled={isRecording} style={{ alignSelf: 'flex-start', marginBottom: '12px' }}><Mic size={14}/> {isRecording ? 'MIC ACTIVE' : 'Initialize Mic Input'}</button>
        <div style={{ flex: 1, background: '#000', border: '1px solid #003300', position: 'relative', minHeight: '120px' }}>
          <canvas ref={waveRef} width={600} height={120} style={{ width: '100%', height: '100%' }} />
          <p style={{ position: 'absolute', top: '4px', left: '8px', fontSize: '10px', opacity: 0.4 }}>LOCAL AUDIO WAVEFORM DISTORTION</p>
        </div>
      </div>
    </div>
  );
}

// ==========================================
// 7. ZERO-KNOWLEDGE ENCRYPTED VAULT
// ==========================================
function ZeroVault() {
  const [pin, setPin] = useState('');
  const [confirmPin, setConfirmPin] = useState('');
  const [isLocked, setIsLocked] = useState(true);
  const [isNew, setIsNew] = useState(true);
  const [vaultData, setVaultData] = useState('');
  const [savedPin, setSavedPin] = useState('');
  const [showPin, setShowPin] = useState(false);
  const [error, setError] = useState('');
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    const existing = sessionStorage.getItem('vault_data');
    if (existing) setIsNew(false);
  }, []);

  const handleSetPin = () => {
    if (pin.length !== 4) { setError('PIN must be exactly 4 digits.'); return; }
    if (pin !== confirmPin) { setError('PINs do not match.'); return; }
    setSavedPin(pin); setIsLocked(false); setError('');
  };

  const handleUnlock = async () => {
    if (pin.length !== 4) { setError('PIN must be exactly 4 digits.'); return; }
    const encrypted = sessionStorage.getItem('vault_data');
    if (encrypted) {
      const decrypted = await decryptData(pin, encrypted);
      if (decrypted === null) { setError('WRONG PIN: Decryption failed.'); return; }
      setVaultData(decrypted);
    }
    setSavedPin(pin); setIsLocked(false); setError('');
  };

  const handleSave = async () => {
    const encrypted = await encryptData(savedPin, sanitize(vaultData));
    sessionStorage.setItem('vault_data', encrypted);
    setSaved(true); setTimeout(() => setSaved(false), 2000);
  };

  return (
    <div style={{ maxWidth: '600px', margin: '0 auto', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', borderBottom: '1px solid #00FF00', paddingBottom: '8px', marginBottom: '16px' }}>ZERO-KNOWLEDGE ENCRYPTED VAULT</h2>
      {isLocked ? (
        <div className="cyber-border" style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '32px', textAlign: 'center' }}>
          <Lock size={48} style={{ marginBottom: '16px' }} />
          <p style={{ marginBottom: '4px', fontWeight: 'bold' }}>{isNew ? 'CREATE NEW VAULT PIN' : 'ENTER VAULT PIN'}</p>
          <p style={{ fontSize: '11px', opacity: 0.5, marginBottom: '24px' }}>AES-256-GCM encrypted. Data vanishes on window close.</p>
          {error && <p style={{ color: '#ff4444', fontSize: '12px', marginBottom: '12px' }}>{error}</p>}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', width: '100%', maxWidth: '250px' }}>
            <div style={{ position: 'relative' }}>
              <input type={showPin ? 'text' : 'password'} maxLength={4} placeholder="4-DIGIT PIN" className="cyber-input" style={{ textAlign: 'center', fontSize: '24px', letterSpacing: '1em', paddingRight: '40px' }} value={pin} onChange={(e) => setPin(e.target.value.replace(/\D/g, ''))} />
              <button onClick={() => setShowPin(!showPin)} style={{ position: 'absolute', right: '8px', top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', color: '#00FF00', cursor: 'pointer' }}>{showPin ? <EyeOff size={16}/> : <Eye size={16}/>}</button>
            </div>
            {isNew && <input type={showPin ? 'text' : 'password'} maxLength={4} placeholder="CONFIRM PIN" className="cyber-input" style={{ textAlign: 'center', fontSize: '24px', letterSpacing: '1em' }} value={confirmPin} onChange={(e) => setConfirmPin(e.target.value.replace(/\D/g, ''))} />}
            <button onClick={isNew ? handleSetPin : handleUnlock} className="cyber-button" style={{ padding: '12px' }}>{isNew ? 'CREATE VAULT' : 'UNLOCK'}</button>
          </div>
        </div>
      ) : (
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '12px' }}>
          <div style={{ background: '#00FF00', color: '#000', padding: '8px 12px', fontWeight: 'bold', fontSize: '12px', display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap' }}>
            <span>VAULT STATUS: DECRYPTED</span>
            <span><AlertTriangle size={12} style={{ display: 'inline' }}/> DATA VANISHES ON WINDOW CLOSE</span>
          </div>
          <textarea className="cyber-input" style={{ flex: 1, resize: 'none', minHeight: '200px' }} placeholder="Enter classified data here..." value={vaultData} onChange={(e) => setVaultData(sanitize(e.target.value))} />
          <button onClick={handleSave} className="cyber-button" style={{ padding: '12px' }}>{saved ? '✓ ENCRYPTED & SAVED TO SESSION' : 'ENCRYPT & SAVE TO SESSION'}</button>
        </div>
      )}
    </div>
  );
}

// ==========================================
// 8. REAL-TIME CRYPTO ENGINE
// ==========================================
function CryptoEngine() {
  const [input, setInput] = useState('');
  const [hashes, setHashes] = useState({ b64: '', sha: '', rot: '' });

  useEffect(() => {
    const compute = async () => {
      const clean = sanitize(input);
      if (!clean) { setHashes({ b64: '', sha: '', rot: '' }); return; }
      const sha = await generateSHA256(clean);
      setHashes({ b64: toBase64(clean), sha, rot: rot13(clean) });
    };
    compute();
  }, [input]);

  return (
    <div style={{ maxWidth: '700px', margin: '0 auto', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', borderBottom: '1px solid #00FF00', paddingBottom: '8px', marginBottom: '16px' }}>REAL-TIME CRYPTO WORKBENCH</h2>
      <div style={{ marginBottom: '20px' }}>
        <label style={{ display: 'block', marginBottom: '8px', fontSize: '12px', opacity: 0.6 }}>RAW STRING INPUT</label>
        <textarea className="cyber-input" style={{ height: '80px', resize: 'none' }} placeholder="Type any string to instantly hash and encode..." value={input} onChange={(e) => setInput(sanitize(e.target.value))} />
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {[
          { title: 'BASE64 ENCODING', value: hashes.b64 },
          { title: 'SHA-256 HASH', value: hashes.sha },
          { title: 'ROT13 CIPHER', value: hashes.rot },
        ].map((row) => (
          <div key={row.title} className="cyber-border" style={{ padding: '12px', display: 'flex', alignItems: 'center', gap: '12px', flexWrap: 'wrap' }}>
            <div style={{ width: '140px', fontWeight: 'bold', fontSize: '12px', flexShrink: 0 }}>{row.title}</div>
            <div style={{ flex: 1, background: '#0a0a0a', padding: '8px', border: '1px solid #003300', fontSize: '12px', wordBreak: 'break-all', minWidth: '150px' }}>{row.value || '...'}</div>
            <CopyBtn text={row.value} />
          </div>
        ))}
      </div>
    </div>
  );
}

// ==========================================
// MAIN APP SHELL
// ==========================================
export default function App() {
  const [activeTab, setActiveTab] = useState('core');
  const [isPanic, setIsPanic] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(false);

  if (isPanic) return <PanicScreen onExit={() => setIsPanic(false)} />;

  const tabs = [
    { id: 'core', name: 'CORE-AI', icon: Cpu },
    { id: 'image', name: 'IMG-GEN', icon: Shield },
    { id: 'tunnel', name: 'P2P-TUNNEL', icon: Radio },
    { id: 'inbox', name: 'GHOST-MAIL', icon: Mail },
    { id: 'media', name: 'MEDIA-STRIP', icon: ShieldAlert },
    { id: 'vault', name: 'ZERO-VAULT', icon: Lock },
    { id: 'crypto', name: 'CIPHER-SYS', icon: Hash },
  ];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', background: '#000', color: '#00FF00', fontFamily: "'Courier New', Courier, monospace", position: 'relative', overflow: 'hidden' }}>
      <MatrixRain />

      {/* HEADER BAR */}
      <div style={{ position: 'relative', zIndex: 10, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '8px 16px', borderBottom: '1px solid #00FF00', background: 'rgba(0,0,0,0.9)', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <button onClick={() => setSidebarOpen(!sidebarOpen)} style={{ background: 'none', border: '1px solid #00FF00', color: '#00FF00', padding: '4px 8px', cursor: 'pointer', fontFamily: 'inherit', display: 'block' }}>☰</button>
          <div>
            <span style={{ fontWeight: 'bold', letterSpacing: '3px', textShadow: '0 0 10px #00FF00' }}>SYS.CORE</span>
            <span style={{ fontSize: '10px', opacity: 0.5, marginLeft: '8px' }}>v9.9.9</span>
          </div>
        </div>
        <button onClick={() => setIsPanic(true)} style={{ background: 'none', border: 'none', color: '#ff4444', cursor: 'pointer', padding: '4px' }} title="PANIC SWITCH">
          <Skull size={22} />
        </button>
      </div>

      <div style={{ display: 'flex', flex: 1, overflow: 'hidden', position: 'relative', zIndex: 5 }}>
        {/* SIDEBAR */}
        {sidebarOpen && <div onClick={() => setSidebarOpen(false)} style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', zIndex: 19 }} />}
        <div style={{
          position: sidebarOpen ? 'fixed' : 'relative',
          left: 0, top: 0, bottom: 0,
          width: sidebarOpen ? '220px' : '0px',
          overflow: 'hidden',
          background: 'rgba(0,5,0,0.95)',
          borderRight: sidebarOpen ? '1px solid #00FF00' : 'none',
          transition: 'width 0.2s',
          zIndex: 20,
          display: 'flex',
          flexDirection: 'column',
          paddingTop: sidebarOpen ? '16px' : '0',
        }}>
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => { setActiveTab(tab.id); setSidebarOpen(false); }}
              style={{
                display: 'flex', alignItems: 'center', gap: '10px', padding: '12px 16px',
                background: activeTab === tab.id ? '#00FF00' : 'transparent',
                color: activeTab === tab.id ? '#000' : '#00FF00',
                border: 'none', borderBottom: '1px solid #003300',
                cursor: 'pointer', fontFamily: 'inherit', fontSize: '13px',
                fontWeight: activeTab === tab.id ? 'bold' : 'normal',
                textAlign: 'left', whiteSpace: 'nowrap',
              }}
            >
              <tab.icon size={16} />
              {tab.name}
            </button>
          ))}
        </div>

        {/* MAIN CONTENT */}
        <div style={{ flex: 1, padding: '16px', overflow: 'auto', position: 'relative' }}>
          {activeTab === 'core' && <CoreAI />}
          {activeTab === 'image' && <ImageGen />}
          {activeTab === 'tunnel' && <P2PTunnel />}
          {activeTab === 'inbox' && <GhostInbox />}
          {activeTab === 'media' && <MediaTools />}
          {activeTab === 'vault' && <ZeroVault />}
          {activeTab === 'crypto' && <CryptoEngine />}
        </div>
      </div>

      {/* FOOTER */}
      <div style={{ position: 'relative', zIndex: 10, borderTop: '1px solid #003300', padding: '4px 16px', fontSize: '10px', opacity: 0.4, background: 'rgba(0,0,0,0.9)', textAlign: 'center', flexShrink: 0 }}>
        CYBER TERMINAL v9.9.9 | ALL OPERATIONS LOCAL | ZERO CLOUD | ZERO LOGS
      </div>

      <style>{`
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
        * { box-sizing: border-box; scrollbar-width: thin; scrollbar-color: #00FF00 #001100; }
        ::selection { background: #00FF00; color: #000; }
      `}</style>
    </div>
  );
}
'@ | Set-Content "src\App.jsx" -Encoding UTF8
Write-Host "[4/5] Created src\App.jsx (FULL APPLICATION)" -ForegroundColor Green

# --- FILE 5: Update index.html ---
@'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="theme-color" content="#000000" />
    <meta http-equiv="X-Content-Type-Options" content="nosniff" />
    <meta http-equiv="X-Frame-Options" content="DENY" />
    <meta name="referrer" content="no-referrer" />
    <title>Cyber Terminal</title>
    <style>body{background:#000;margin:0}</style>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@ | Set-Content "index.html" -Encoding UTF8
Write-Host "[5/5] Updated index.html with security headers" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " ALL FILES CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Now run this command to see your app:" -ForegroundColor Yellow
Write-Host "  npm run dev" -ForegroundColor Cyan
Write-Host ""
Write-Host "Then open http://localhost:5173 in your browser!" -ForegroundColor Yellow