# === CYBER TERMINAL V2 - HOLLYWOOD EDITION AUTO-BUILDER ===
Set-Location "C:\Users\gokul\cyber-terminal"
Write-Host "============================================" -ForegroundColor Green
Write-Host " CYBER TERMINAL V2 - HOLLYWOOD EDITION" -ForegroundColor Green
Write-Host " BUILDING ALL FILES AUTOMATICALLY..." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green

# --- FILE 1: src\index.css ---
@'
@import "tailwindcss";

@layer base {
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background-color: #000000;
    color: #00FF00;
    margin: 0;
    overflow: hidden;
    font-family: 'Courier New', Courier, monospace;
    -webkit-font-smoothing: antialiased;
  }
  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: #000; }
  ::-webkit-scrollbar-thumb { background: #00FF00; border-radius: 3px; }
  ::selection { background: #00FF00; color: #000; }
}

@layer components {
  .glow { text-shadow: 0 0 5px #00FF00, 0 0 10px #00FF00, 0 0 20px #00FF00; }
  .glow-red { text-shadow: 0 0 5px #ff0040, 0 0 10px #ff0040; }
  .glow-cyan { text-shadow: 0 0 5px #00ffff, 0 0 10px #00ffff; }
  .glow-box {
    border: 1px solid #00FF00;
    box-shadow: 0 0 10px rgba(0,255,0,0.3), 0 0 20px rgba(0,255,0,0.1), inset 0 0 10px rgba(0,255,0,0.05);
    background: rgba(0,15,0,0.7);
  }
  .glow-box-cyan {
    border: 1px solid #00ffff;
    box-shadow: 0 0 10px rgba(0,255,255,0.3), inset 0 0 10px rgba(0,255,255,0.05);
    background: rgba(0,10,15,0.7);
  }
  .cyber-input {
    background: rgba(0,20,0,0.9);
    border: 1px solid #00FF00;
    color: #00FF00;
    outline: none;
    width: 100%;
    padding: 10px 12px;
    font-family: 'Courier New', monospace;
    font-size: 14px;
    transition: all 0.3s;
  }
  .cyber-input:focus {
    box-shadow: 0 0 20px rgba(0,255,0,0.5);
    border-color: #00ffaa;
  }
  .cyber-input:disabled {
    opacity: 0.3;
    cursor: not-allowed;
  }
  .cyber-btn {
    background: transparent;
    border: 1px solid #00FF00;
    color: #00FF00;
    text-transform: uppercase;
    padding: 10px 20px;
    font-family: 'Courier New', monospace;
    font-weight: bold;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    letter-spacing: 1px;
    position: relative;
    overflow: hidden;
  }
  .cyber-btn::before {
    content: '';
    position: absolute;
    top: 0; left: -100%;
    width: 100%; height: 100%;
    background: linear-gradient(90deg, transparent, rgba(0,255,0,0.2), transparent);
    transition: left 0.5s;
  }
  .cyber-btn:hover::before { left: 100%; }
  .cyber-btn:hover:not(:disabled) {
    background: #00FF00;
    color: #000;
    box-shadow: 0 0 30px rgba(0,255,0,0.6);
    transform: translateY(-1px);
  }
  .cyber-btn:active:not(:disabled) { transform: scale(0.97); }
  .cyber-btn:disabled {
    border-color: #003300;
    color: #003300;
    cursor: not-allowed;
  }
  .cyber-btn-red {
    border-color: #ff0040;
    color: #ff0040;
  }
  .cyber-btn-red:hover:not(:disabled) {
    background: #ff0040;
    color: #000;
    box-shadow: 0 0 30px rgba(255,0,64,0.6);
  }
  .cyber-btn-cyan {
    border-color: #00ffff;
    color: #00ffff;
  }
  .cyber-btn-cyan:hover:not(:disabled) {
    background: #00ffff;
    color: #000;
    box-shadow: 0 0 30px rgba(0,255,255,0.6);
  }
  .scanlines {
    position: fixed; top: 0; left: 0; right: 0; bottom: 0;
    pointer-events: none; z-index: 9998;
    background: repeating-linear-gradient(0deg, rgba(0,0,0,0.15) 0px, rgba(0,0,0,0.15) 1px, transparent 1px, transparent 3px);
  }
}
'@ | Set-Content "src\index.css" -Encoding UTF8
Write-Host "[1/4] Created index.css" -ForegroundColor Green

# --- FILE 2: src\utils.js ---
@'
// === STRICT XSS SANITIZATION ENGINE v2 ===
export const sanitize = (input) => {
  if (!input) return '';
  let c = input.toString();
  c = c.replace(/<[^>]*>?/gm, '');
  c = c.replace(/javascript\s*:/gi, '');
  c = c.replace(/on\w+\s*=/gi, '');
  c = c.replace(/data\s*:/gi, '');
  c = c.replace(/vbscript\s*:/gi, '');
  c = c.replace(/expression\s*\(/gi, '');
  c = c.replace(/eval\s*\(/gi, '');
  c = c.replace(/document\.\w+/gi, '');
  c = c.replace(/window\.\w+/gi, '');
  c = c.replace(/\.constructor/gi, '');
  c = c.replace(/__proto__/gi, '');
  return c;
};

// === CRYPTO ENGINE ===
export const rot13 = (s) => s.replace(/[a-zA-Z]/g, c => String.fromCharCode((c<='Z'?90:122)>=(c=c.charCodeAt(0)+13)?c:c-26));

export const generateSHA256 = async (t) => {
  if(!t) return '';
  const h = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(t));
  return Array.from(new Uint8Array(h)).map(b=>b.toString(16).padStart(2,'0')).join('');
};

export const toBase64 = (t) => { if(!t) return ''; try{return btoa(unescape(encodeURIComponent(t)))}catch(e){return 'ERR'} };

export const textToBinary = (t) => t.split('').map(c=>c.charCodeAt(0).toString(2).padStart(8,'0')).join(' ');
export const textToHex = (t) => t.split('').map(c=>c.charCodeAt(0).toString(16).padStart(2,'0')).join(' ');
export const textToOctal = (t) => t.split('').map(c=>c.charCodeAt(0).toString(8).padStart(3,'0')).join(' ');

export const textToMorse = (t) => {
  const m = {'A':'.-','B':'-...','C':'-.-.','D':'-..','E':'.','F':'..-.','G':'--.','H':'....','I':'..','J':'.---','K':'-.-','L':'.-..','M':'--','N':'-.','O':'---','P':'.--.','Q':'--.-','R':'.-.','S':'...','T':'-','U':'..-','V':'...-','W':'.--','X':'-..-','Y':'-.--','Z':'--..','0':'-----','1':'.----','2':'..---','3':'...--','4':'....-','5':'.....','6':'-....','7':'--...','8':'---..','9':'----.',' ':'/'};
  return t.toUpperCase().split('').map(c=>m[c]||c).join(' ');
};

export const morseToText = (m) => {
  const d = {'.-':'A','-...':'B','-.-.':'C','-..':'D','.':'E','..-.':'F','--.':'G','....':'H','..':'I','.---':'J','-.-':'K','.-..':'L','--':'M','-.':'N','---':'O','.--.':'P','--.-':'Q','.-.':'R','...':'S','-':'T','..-':'U','...-':'V','.--':'W','-..-':'X','-.--':'Y','--..':'Z','-----':'0','.----':'1','..---':'2','...--':'3','....-':'4','.....':'5','-....':'6','--...':'7','---..':'8','----.':'9','/':' '};
  return m.split(' ').map(c=>d[c]||c).join('');
};

// === AES-256-GCM VAULT ENCRYPTION ===
export const deriveKey = async (pin) => {
  const km = await crypto.subtle.importKey('raw', new TextEncoder().encode(pin), 'PBKDF2', false, ['deriveKey']);
  return crypto.subtle.deriveKey({name:'PBKDF2',salt:new TextEncoder().encode('CYB3R_S4LT_V9'),iterations:100000,hash:'SHA-256'},km,{name:'AES-GCM',length:256},false,['encrypt','decrypt']);
};
export const encryptData = async (pin, txt) => {
  const k = await deriveKey(pin); const iv = crypto.getRandomValues(new Uint8Array(12));
  const ct = await crypto.subtle.encrypt({name:'AES-GCM',iv},k,new TextEncoder().encode(txt));
  const c = new Uint8Array(iv.byteLength+ct.byteLength); c.set(iv,0); c.set(new Uint8Array(ct),iv.byteLength);
  return btoa(String.fromCharCode(...c));
};
export const decryptData = async (pin, enc) => {
  try { const k=await deriveKey(pin); const r=Uint8Array.from(atob(enc),c=>c.charCodeAt(0));
  const d=await crypto.subtle.decrypt({name:'AES-GCM',iv:r.slice(0,12)},k,r.slice(12));
  return new TextDecoder().decode(d); } catch(e){return null;}
};

// === EXIF STRIPPER ===
export const stripExif = async (file) => {
  const buf = await file.arrayBuffer(); const v = new DataView(buf);
  if(v.getUint16(0)!==0xFFD8) return file;
  let o=2; const p=[buf.slice(0,2)];
  while(o<v.byteLength-1){ const m=v.getUint16(o);
    if(m===0xFFDA){p.push(buf.slice(o));break;}
    const l=v.getUint16(o+2);
    if(m>=0xFFE1&&m<=0xFFEF){o+=2+l;continue;}
    p.push(buf.slice(o,o+2+l)); o+=2+l;
  } return new Blob(p,{type:'image/jpeg'});
};

// === PASSWORD GENERATOR ===
export const generatePassword = (length, options) => {
  let chars = '';
  if(options.upper) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if(options.lower) chars += 'abcdefghijklmnopqrstuvwxyz';
  if(options.numbers) chars += '0123456789';
  if(options.symbols) chars += '!@#$%^&*()_+-=[]{}|;:,.<>?';
  if(!chars) chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  const arr = new Uint32Array(length);
  crypto.getRandomValues(arr);
  return Array.from(arr, v => chars[v % chars.length]).join('');
};

export const getPasswordStrength = (pw) => {
  let score = 0;
  if(pw.length >= 8) score++; if(pw.length >= 12) score++; if(pw.length >= 16) score++; if(pw.length >= 24) score++;
  if(/[a-z]/.test(pw)) score++; if(/[A-Z]/.test(pw)) score++; if(/[0-9]/.test(pw)) score++; if(/[^a-zA-Z0-9]/.test(pw)) score++;
  if(score <= 2) return {label:'WEAK',color:'#ff0040',percent:25};
  if(score <= 4) return {label:'MEDIUM',color:'#ffaa00',percent:50};
  if(score <= 6) return {label:'STRONG',color:'#00ff88',percent:75};
  return {label:'FORTRESS',color:'#00ffff',percent:100};
};

// === SOUND ENGINE ===
export const playBeep = (freq=800, dur=80, type='square') => {
  try {
    const ctx = new (window.AudioContext||window.webkitAudioContext)();
    const osc = ctx.createOscillator(); const gain = ctx.createGain();
    osc.type = type; osc.frequency.value = freq;
    gain.gain.value = 0.08;
    osc.connect(gain); gain.connect(ctx.destination);
    osc.start(); osc.stop(ctx.currentTime + dur/1000);
  } catch(e){}
};

// === CSP ===
export const enforceCSP = () => {
  const m = document.createElement('meta');
  m.httpEquiv = 'Content-Security-Policy';
  m.content = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; connect-src 'self' https://www.1secmail.com https://ipapi.co; img-src 'self' blob: data:; media-src 'self' blob:;";
  document.head.appendChild(m);
};
'@ | Set-Content "src\utils.js" -Encoding UTF8
Write-Host "[2/4] Created utils.js" -ForegroundColor Green

# --- FILE 3: src\main.jsx ---
@'
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { enforceCSP } from './utils'
enforceCSP();
createRoot(document.getElementById('root')).render(<StrictMode><App /></StrictMode>)
'@ | Set-Content "src\main.jsx" -Encoding UTF8
Write-Host "[3/4] Created main.jsx" -ForegroundColor Green

# --- FILE 4: src\App.jsx (FULL HOLLYWOOD EDITION) ---
@'
import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Shield, Key, Lock, Hash, Radio, Mail, Skull, Copy, FileDigit, ShieldAlert, Cpu, Mic, Download, CheckCircle, AlertTriangle, Eye, EyeOff, Volume2, Wifi, Globe, KeyRound, Binary, Zap, Terminal, Activity } from 'lucide-react';
import { sanitize, generateSHA256, toBase64, rot13, stripExif, encryptData, decryptData, textToBinary, textToHex, textToOctal, textToMorse, morseToText, generatePassword, getPasswordStrength, playBeep } from './utils';

/* =============================================
   BOOT SEQUENCE - HOLLYWOOD STARTUP ANIMATION
============================================= */
function BootSequence({ onComplete }) {
  const [lines, setLines] = useState([]);
  const [done, setDone] = useState(false);
  const bootLines = [
    { text: 'BIOS CHECK............................... OK', delay: 200 },
    { text: 'MEMORY TEST [16384 MB]................... PASS', delay: 300 },
    { text: 'LOADING KERNEL v9.9.9.................... OK', delay: 250 },
    { text: 'INITIALIZING SECURE BOOT CHAIN........... OK', delay: 400 },
    { text: 'MOUNTING ENCRYPTED FILESYSTEM............. OK', delay: 300 },
    { text: 'LOADING CRYPTO ENGINE [AES-256-GCM]...... OK', delay: 350 },
    { text: 'ESTABLISHING QUANTUM-SAFE TUNNEL......... OK', delay: 500 },
    { text: 'XSS INJECTION FIREWALL................... ARMED', delay: 200 },
    { text: 'NEURAL NETWORK CORE...................... STANDBY', delay: 300 },
    { text: 'ANONYMITY LAYER.......................... ACTIVE', delay: 250 },
    { text: 'ZERO-LOG PROTOCOL........................ ENFORCED', delay: 200 },
    { text: '', delay: 300 },
    { text: '>>> ALL SYSTEMS NOMINAL <<<', delay: 400 },
    { text: '>>> LAUNCHING CYBER TERMINAL v9.9.9 <<<', delay: 600 },
  ];

  useEffect(() => {
    let i = 0;
    const addLine = () => {
      if (i < bootLines.length) {
        const line = bootLines[i];
        setLines(prev => [...prev, line.text]);
        playBeep(400 + Math.random() * 600, 30);
        i++;
        setTimeout(addLine, line.delay);
      } else {
        playBeep(1200, 200, 'sine');
        setTimeout(() => { setDone(true); setTimeout(onComplete, 800); }, 500);
      }
    };
    setTimeout(addLine, 500);
  }, []);

  return (
    <div style={{ position:'fixed', inset:0, background:'#000', zIndex:99999, display:'flex', alignItems:'center', justifyContent:'center', fontFamily:"'Courier New', monospace" }}>
      <div style={{ maxWidth:'700px', width:'90%', padding:'20px' }}>
        <div style={{ color:'#00FF00', marginBottom:'24px', fontSize:'20px', fontWeight:'bold', textShadow:'0 0 20px #00FF00', textAlign:'center', letterSpacing:'6px' }}>
          CYBER TERMINAL
        </div>
        <div style={{ border:'1px solid #003300', padding:'16px', background:'rgba(0,10,0,0.8)', minHeight:'300px', fontSize:'12px', lineHeight:'1.8' }}>
          {lines.map((line, idx) => (
            <div key={idx} style={{ color: line.includes('<<<') ? '#00ffff' : line.includes('ARMED') ? '#ff0040' : '#00FF00', textShadow: line.includes('<<<') ? '0 0 10px #00ffff' : 'none' }}>
              {line}
            </div>
          ))}
          {!done && <span style={{ animation:'blink 0.5s infinite', color:'#00FF00' }}>_</span>}
        </div>
        {done && (
          <div style={{ textAlign:'center', marginTop:'16px', color:'#00ffff', fontSize:'14px', animation:'pulse 1s infinite', textShadow:'0 0 15px #00ffff' }}>
            ACCESS GRANTED
          </div>
        )}
      </div>
    </div>
  );
}

/* =============================================
   MATRIX RAIN BACKGROUND
============================================= */
function MatrixRain() {
  const ref = useRef(null);
  useEffect(() => {
    const c = ref.current; if(!c) return;
    const ctx = c.getContext('2d');
    const resize = () => { c.width=window.innerWidth; c.height=window.innerHeight; };
    resize(); window.addEventListener('resize', resize);
    const cols = Math.floor(c.width/16);
    const drops = Array(cols).fill(1);
    const chars = 'アイウエオカキクケコサシスセソタチツテトナニヌネノ01234567890ABCDEF<>/{}[]!@#$%';
    const draw = () => {
      ctx.fillStyle = 'rgba(0,0,0,0.06)';
      ctx.fillRect(0,0,c.width,c.height);
      for(let i=0;i<drops.length;i++){
        const ch = chars[Math.floor(Math.random()*chars.length)];
        const bright = Math.random();
        ctx.fillStyle = bright > 0.95 ? '#ffffff' : bright > 0.8 ? '#00ff88' : '#00FF00';
        ctx.font = (bright > 0.9 ? 'bold ' : '') + '15px monospace';
        ctx.fillText(ch, i*16, drops[i]*16);
        if(drops[i]*16 > c.height && Math.random()>0.975) drops[i]=0;
        drops[i]++;
      }
    };
    const iv = setInterval(draw, 45);
    return () => { clearInterval(iv); window.removeEventListener('resize', resize); };
  }, []);
  return <canvas ref={ref} style={{ position:'fixed', top:0, left:0, zIndex:0, opacity:0.12, pointerEvents:'none' }} />;
}

/* =============================================
   GLITCH TEXT COMPONENT
============================================= */
function GlitchText({ text, size = '20px' }) {
  return (
    <div style={{ position:'relative', fontSize:size, fontWeight:'bold', letterSpacing:'3px' }}>
      <span style={{ position:'relative', display:'inline-block', animation:'glitch1 2.5s infinite' }}>{text}</span>
    </div>
  );
}

/* =============================================
   TYPING TEXT EFFECT
============================================= */
function TypeText({ text, speed = 50, style = {} }) {
  const [displayed, setDisplayed] = useState('');
  useEffect(() => {
    let i = 0; setDisplayed('');
    const iv = setInterval(() => {
      if(i < text.length) { setDisplayed(text.slice(0, i+1)); i++; }
      else clearInterval(iv);
    }, speed);
    return () => clearInterval(iv);
  }, [text]);
  return <span style={style}>{displayed}<span style={{ animation:'blink 0.6s infinite' }}>|</span></span>;
}

/* =============================================
   LIVE SYSTEM STATS BAR
============================================= */
function SystemStats() {
  const [stats, setStats] = useState({ cpu: 0, ram: 0, net: 0, uptime: 0 });
  useEffect(() => {
    const iv = setInterval(() => {
      setStats({
        cpu: (15 + Math.random() * 35).toFixed(1),
        ram: (40 + Math.random() * 25).toFixed(1),
        net: (Math.random() * 100).toFixed(0),
        uptime: prev => prev + 1
      });
    }, 2000);
    return () => clearInterval(iv);
  }, []);
  const [up, setUp] = useState(0);
  useEffect(() => { const iv = setInterval(() => setUp(p=>p+1), 1000); return ()=>clearInterval(iv); }, []);
  const fmt = (s) => { const m=Math.floor(s/60); const h=Math.floor(m/60); return `${h}h ${m%60}m ${s%60}s`; };
  return (
    <div style={{ display:'flex', gap:'16px', fontSize:'10px', opacity:0.6, flexWrap:'wrap', justifyContent:'center' }}>
      <span>CPU: <span style={{color:'#00ffaa'}}>{stats.cpu}%</span></span>
      <span>RAM: <span style={{color:'#00ffaa'}}>{stats.ram}%</span></span>
      <span>NET: <span style={{color:'#00ffaa'}}>{stats.net} KB/s</span></span>
      <span>UPTIME: <span style={{color:'#00ffaa'}}>{fmt(up)}</span></span>
      <span>PID: <span style={{color:'#00ffff'}}>0x{Math.floor(Math.random()*65535).toString(16).toUpperCase()}</span></span>
    </div>
  );
}

/* =============================================
   AD COUNTDOWN WITH MATRIX EFFECT
============================================= */
function AdCountdown({ label, seconds, onComplete }) {
  const [count, setCount] = useState(seconds);
  const [progress, setProgress] = useState(0);
  useEffect(() => {
    const t = setInterval(() => {
      setCount(p => { if(p<=1){clearInterval(t);onComplete();return 0;} return p-1; });
      setProgress(p => Math.min(p+(100/seconds),100));
      playBeep(300+Math.random()*400, 20);
    }, 1000);
    return () => clearInterval(t);
  }, []);
  return (
    <div style={{ position:'fixed', inset:0, zIndex:9999, background:'#000', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center' }}>
      <MatrixRain />
      <div style={{ position:'relative', zIndex:1, textAlign:'center' }}>
        <p style={{ color:'#00FF00', fontSize:'12px', letterSpacing:'4px', marginBottom:'32px' }} className="glow">{label}</p>
        <div style={{ fontSize:'140px', fontWeight:'bold', lineHeight:1 }} className="glow">{count}</div>
        <div style={{ width:'300px', height:'4px', background:'#003300', margin:'40px auto 0', borderRadius:'2px', overflow:'hidden' }}>
          <div style={{ height:'100%', background:'linear-gradient(90deg, #00FF00, #00ffff)', width:`${progress}%`, transition:'width 1s linear', boxShadow:'0 0 10px #00FF00' }} />
        </div>
        <p style={{ color:'#003300', fontSize:'10px', marginTop:'20px', letterSpacing:'2px' }}>DECRYPTING SPONSORED DATA STREAM</p>
      </div>
    </div>
  );
}

/* =============================================
   COPY BUTTON
============================================= */
function CopyBtn({ text, label='COPY' }) {
  const [ok, setOk] = useState(false);
  return (
    <button onClick={() => { navigator.clipboard.writeText(text); setOk(true); playBeep(1000,50,'sine'); setTimeout(()=>setOk(false),1500); }}
      className={ok ? "cyber-btn cyber-btn-cyan" : "cyber-btn"} style={{ padding:'6px 12px', fontSize:'11px', minWidth:'70px' }}>
      {ok ? <><CheckCircle size={12}/> OK</> : <><Copy size={12}/> {label}</>}
    </button>
  );
}

/* =============================================
   SECTION HEADER
============================================= */
function SectionHeader({ icon: Icon, title, subtitle }) {
  return (
    <div style={{ borderBottom:'1px solid #00FF00', paddingBottom:'12px', marginBottom:'16px' }}>
      <div style={{ display:'flex', alignItems:'center', gap:'10px' }}>
        {Icon && <Icon size={22} />}
        <GlitchText text={title} />
      </div>
      {subtitle && <p style={{ fontSize:'11px', opacity:0.4, marginTop:'4px', letterSpacing:'1px' }}>{subtitle}</p>}
    </div>
  );
}

/* =============================================
   PANIC MODE - FAKE NOTEPAD
============================================= */
function PanicScreen({ onExit }) {
  return (
    <div style={{ position:'fixed', inset:0, background:'#fff', zIndex:99999 }}>
      <div style={{ background:'#f0f0f0', padding:'4px 12px', borderBottom:'1px solid #ccc', display:'flex', gap:'20px', fontSize:'13px', fontFamily:'Segoe UI, sans-serif', color:'#333' }}>
        <span style={{fontWeight:'bold'}}>Notepad</span>
        <span>File</span><span>Edit</span><span>Format</span><span>View</span><span>Help</span>
      </div>
      <textarea style={{ width:'100%', height:'calc(100% - 30px)', border:'none', outline:'none', padding:'12px', fontFamily:'Consolas', fontSize:'14px', color:'#333', resize:'none' }}
        defaultValue={"Shopping List:\n- Milk\n- Eggs 6pc\n- Bread (whole wheat)\n- Rice 5kg\n- Sugar 1kg\n- Cooking oil\n\nMeeting Notes - Sept 13:\n- Review quarterly report\n- Budget allocation discussion\n- Team building activity Friday\n- Submit timesheet by EOD\n\nReminders:\n- Pay electricity bill before 15th\n- Dentist appointment next Tuesday\n- Return library books\n- Birthday gift for mom"} />
      <button onClick={onExit} style={{ position:'fixed', bottom:0, right:0, width:'15px', height:'15px', opacity:0, cursor:'default' }} />
    </div>
  );
}

/* =============================================
   1. CORE-AI PREMIUM TERMINAL
============================================= */
function CoreAI() {
  const [key, setKey] = useState('');
  const [status, setStatus] = useState('AWAITING ACTIVATION...');
  const [checking, setChecking] = useState(false);
  const blurred = [
    '> [CLASSIFIED] Initializing neural exploit framework v7.2...',
    '> Compiling polymorphic payload with AES-256 obfuscation...',
    '> Deploying steganographic data exfil via DNS tunneling...',
    '> Bypassing IDS/IPS with protocol-level fragmentation...',
    '> Quantum-resistant key exchange established on port 443...',
    '> Zero-day kernel module loaded. Ring-0 access confirmed...',
    '> AI adversarial model confidence: 99.94%. Ready to deploy...',
  ];
  const handleActivate = () => {
    if(key.length!==16){setStatus('ERROR: KEY MUST BE 16 ALPHANUMERIC CHARACTERS');return;}
    setChecking(true); setStatus('ESTABLISHING TLS 1.3 HANDSHAKE...');
    playBeep(600, 100);
    setTimeout(()=>{setStatus('VALIDATING LICENSE AGAINST REMOTE KEYSERVER...');
      setTimeout(()=>{setStatus('ACCESS DENIED: LICENSE KEY NOT FOUND IN DATABASE'); setChecking(false); playBeep(200, 300);}, 2000);
    }, 1500);
  };
  return (
    <div style={{ height:'100%', overflow:'auto', padding:'4px' }}>
      <SectionHeader icon={Cpu} title="CORE-AI: UNCENSORED CLOUD PROTOCOL" subtitle="PREMIUM ACCESS TIER" />
      <div className="glow-box" style={{ padding:'24px', textAlign:'center', marginBottom:'16px' }}>
        <Shield size={48} style={{ margin:'0 auto 12px', animation:'pulse 2s infinite' }} />
        <p style={{ fontSize:'20px', color:'#ff0040', fontWeight:'bold', marginBottom:'16px' }} className="glow-red">ACCESS VALUE: &#8377;55,000 / 1 FULL YEAR PASS</p>
        <div style={{ background:'#000', border:'1px solid #003300', padding:'12px', marginBottom:'20px', fontSize:'11px', maxWidth:'500px', margin:'0 auto 20px' }}>
          <p style={{ fontWeight:'bold', marginBottom:'6px', display:'flex', alignItems:'center', justifyContent:'center', gap:'6px' }}><Key size={12}/> ZERO LOG PRIVACY GUARANTEE</p>
          <p style={{ opacity:0.7 }}>Cloud infrastructure operates on ephemeral RAM. 0% user data stored. 0% prompt logs. Zero IP mapping. Absolute anonymity.</p>
        </div>
        <div style={{ maxWidth:'380px', margin:'0 auto', display:'flex', flexDirection:'column', gap:'10px' }}>
          <input type="text" maxLength={16} placeholder="ENTER 16-DIGIT LICENSE KEY" className="cyber-input" style={{ textAlign:'center', fontSize:'16px', letterSpacing:'0.2em' }} value={key} onChange={(e)=>setKey(sanitize(e.target.value.toUpperCase().replace(/[^A-Z0-9]/g,'')))} />
          <button onClick={handleActivate} className="cyber-btn cyber-btn-red" disabled={checking} style={{ padding:'14px' }}>{checking ? 'VERIFYING...' : 'ACTIVATE LICENSE'}</button>
          <p style={{ fontSize:'10px', opacity:0.5, animation:'pulse 2s infinite' }}>{status}</p>
        </div>
      </div>
      <div style={{ borderTop:'1px solid #003300', paddingTop:'12px', maxHeight:'100px', overflow:'hidden' }}>
        <p style={{ fontSize:'9px', opacity:0.4, marginBottom:'8px' }}>LIVE RESPONSE STREAM [REDACTED]:</p>
        <div style={{ filter:'blur(4px)', fontSize:'10px', lineHeight:2, opacity:0.6 }}>
          {blurred.map((l,i) => <p key={i}>{l}</p>)}
        </div>
      </div>
    </div>
  );
}

/* =============================================
   2. LOCAL AI IMAGE GENERATOR
============================================= */
function ImageGen() {
  const [phase, setPhase] = useState('locked');
  const [prompt, setPrompt] = useState('');
  const [progress, setProgress] = useState(0);
  const [tokens, setTokens] = useState(0);
  const startGen = () => {
    if(tokens<=0||!prompt) return;
    setTokens(t=>t-1); setProgress(1); playBeep(500,50);
    const iv = setInterval(()=>{ setProgress(p=>{if(p>=100){clearInterval(iv);playBeep(1200,150,'sine');return 100;} return Math.min(p+Math.floor(Math.random()*10)+3,100);}); },200);
  };
  if(phase==='ad') return <AdCountdown label="STREAMING SPONSORED DATA PACKET..." seconds={15} onComplete={()=>{setPhase('ready');setTokens(t=>t+1);playBeep(1000,100,'sine');}} />;
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Zap} title="LOCAL AI RENDER NODE" subtitle="CLIENT-SIDE WEBGPU SIMULATION" />
      <div style={{ display:'flex', gap:'8px', marginBottom:'12px', flexWrap:'wrap', alignItems:'center' }}>
        <button onClick={()=>{setPhase('ad');playBeep(400,80);}} className="cyber-btn">Decrypt Ad Stream (+1 Token)</button>
        <span style={{ fontSize:'12px', padding:'4px 12px', border:'1px solid #003300', background:'rgba(0,10,0,0.5)' }}>TOKENS: <span style={{ color:tokens>0?'#00ffff':'#ff0040', fontWeight:'bold' }}>{tokens}</span></span>
      </div>
      <div style={{ display:'flex', gap:'8px', marginBottom:'12px' }}>
        <input type="text" placeholder={tokens>0?"Describe image to generate...":"LOCKED - Earn tokens first"} className="cyber-input" style={{flex:1}} disabled={tokens<=0} value={prompt} onChange={(e)=>setPrompt(sanitize(e.target.value))} />
        <button onClick={startGen} className="cyber-btn cyber-btn-cyan" disabled={tokens<=0||!prompt||(progress>0&&progress<100)}>RENDER</button>
      </div>
      <div className="glow-box" style={{ flex:1, display:'flex', alignItems:'center', justifyContent:'center', padding:'24px', minHeight:'180px' }}>
        {progress===0 && <p style={{opacity:0.3,textAlign:'center'}}>{tokens>0?'Enter prompt and click RENDER':'Watch an ad to earn render tokens'}</p>}
        {progress>0&&progress<100 && (
          <div style={{width:'100%',maxWidth:'400px',textAlign:'center'}}>
            <Activity size={32} style={{margin:'0 auto 12px',animation:'pulse 1s infinite'}} />
            <p style={{fontSize:'11px',marginBottom:'8px'}}>WEBGPU PIPELINE ACTIVE...</p>
            <div style={{width:'100%',height:'12px',border:'1px solid #00FF00',padding:'2px',background:'#000'}}>
              <div style={{height:'100%',background:'linear-gradient(90deg, #003300, #00FF00, #00ffff)',width:`${progress}%`,transition:'width 0.2s',boxShadow:'0 0 8px #00FF00'}} />
            </div>
            <p style={{fontSize:'11px',marginTop:'6px'}}>{progress}%</p>
          </div>
        )}
        {progress>=100 && (
          <div style={{textAlign:'center'}}>
            <CheckCircle size={48} style={{margin:'0 auto 12px',color:'#00ffff'}} />
            <p style={{fontWeight:'bold',fontSize:'16px'}} className="glow-cyan">RENDER COMPLETE</p>
            <p style={{fontSize:'10px',opacity:0.5,margin:'8px 0'}}>Prompt: "{prompt}"</p>
            <button onClick={()=>setProgress(0)} className="cyber-btn" style={{marginTop:'8px'}}>NEW RENDER</button>
          </div>
        )}
      </div>
    </div>
  );
}

/* =============================================
   3. P2P QUANTUM FILE TUNNEL
============================================= */
function P2PTunnel() {
  const [stage, setStage] = useState(0);
  const [files, setFiles] = useState([]);
  const fileRef = useRef(null);
  const handleFiles = (e) => {
    const fs = Array.from(e.target?.files || e.dataTransfer?.files || []);
    if(!fs.length) return;
    playBeep(600, 60);
    setFiles(p=>[...p,...fs.map(f=>({name:f.name,size:f.size,status:'streaming',progress:0}))]);
    fs.forEach((_,i)=>{ setTimeout(()=>{setFiles(p=>p.map((f,idx)=>idx===p.length-fs.length+i?{...f,status:'complete',progress:100}:f)); playBeep(1000,80,'sine');}, 2000+i*1500); });
  };
  if(stage===1) return <AdCountdown label="BYPASSING AD WALL 1/2..." seconds={15} onComplete={()=>setStage(2)} />;
  if(stage===2) return <AdCountdown label="BYPASSING AD WALL 2/2..." seconds={15} onComplete={()=>{setStage(3);playBeep(1200,200,'sine');}} />;
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Radio} title="P2P QUANTUM TUNNEL" subtitle="WEBRTC DIRECT TRANSFER" />
      {stage===0 ? (
        <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'32px', textAlign:'center' }}>
          <Lock size={48} style={{ marginBottom:'16px', color:'#ff0040' }} />
          <p style={{ fontWeight:'bold', marginBottom:'4px' }}>AUTHENTICATION FIREWALL ACTIVE</p>
          <p style={{ fontSize:'11px', opacity:0.5, marginBottom:'24px' }}>Complete 2 sequential ad decryptions (30s total) to unlock</p>
          <button onClick={()=>{setStage(1);playBeep(400,80);}} className="cyber-btn cyber-btn-red" style={{ padding:'16px 32px', fontSize:'14px' }}>UNLOCK SECURE TUNNEL</button>
        </div>
      ) : (
        <div style={{ flex:1, display:'flex', flexDirection:'column', gap:'12px' }}>
          <div style={{ background:'rgba(0,255,0,0.05)', border:'1px solid #00FF00', padding:'10px', fontSize:'10px', fontWeight:'bold', boxShadow:'0 0 15px rgba(0,255,0,0.2)' }}>
            <p style={{display:'flex',alignItems:'center',gap:'6px',marginBottom:'4px',color:'#00ffff'}}><ShieldAlert size={12}/> HARDWARE NOTICE:</p>
            <p>Files stream directly via local hardware WebRTC pipes. Zero cloud servers. Complete isolation.</p>
          </div>
          <input type="file" ref={fileRef} multiple style={{display:'none'}} onChange={handleFiles} />
          <div onClick={()=>fileRef.current?.click()} onDragOver={(e)=>e.preventDefault()} onDrop={(e)=>{e.preventDefault();handleFiles(e);}}
            style={{ flex:1, border:'2px dashed #00FF00', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'24px', cursor:'pointer', minHeight:'120px', background:'rgba(0,255,0,0.02)', transition:'all 0.3s' }}>
            <FileDigit size={40} style={{marginBottom:'8px',opacity:0.4}} />
            <p style={{fontSize:'14px'}}>TAP OR DRAG FILES HERE</p>
            <p style={{opacity:0.3,fontSize:'11px',marginTop:'4px'}}>ANY SIZE / ANY FORMAT</p>
          </div>
          {files.length>0 && (
            <div className="glow-box" style={{padding:'8px',maxHeight:'180px',overflow:'auto'}}>
              {files.map((f,i) => (
                <div key={i} style={{display:'flex',justifyContent:'space-between',alignItems:'center',padding:'6px 8px',borderBottom:'1px solid #001a00',fontSize:'11px'}}>
                  <span style={{flex:1,overflow:'hidden',textOverflow:'ellipsis',whiteSpace:'nowrap'}}>{f.name}</span>
                  <span style={{marginLeft:'8px',flexShrink:0,color:f.status==='complete'?'#00ffff':'#ffaa00',fontWeight:'bold'}}>{f.status==='complete'?'TRANSFERRED':'STREAMING...'}</span>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

/* =============================================
   4. GHOST INBOX
============================================= */
function GhostInbox() {
  const [email, setEmail] = useState('');
  const [msgs, setMsgs] = useState([]);
  const [loading, setLoading] = useState(false);
  const genMail = async () => {
    setLoading(true); playBeep(500,60);
    try { const r=await fetch('https://www.1secmail.com/api/v1/?action=genRandomMailbox&count=1'); const d=await r.json(); setEmail(d[0]); setMsgs([]); playBeep(1000,80,'sine'); } catch(e){}
    setLoading(false);
  };
  useEffect(() => {
    if(!email) return;
    const [login,domain] = email.split('@');
    const iv = setInterval(async()=>{ try{const r=await fetch(`https://www.1secmail.com/api/v1/?action=getMessages&login=${login}&domain=${domain}`);setMsgs(await r.json());}catch(e){} }, 5000);
    return ()=>clearInterval(iv);
  }, [email]);
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Mail} title="GHOST INBOX" subtitle="DISPOSABLE TEMP-MAIL API" />
      <div style={{display:'flex',gap:'8px',marginBottom:'12px',flexWrap:'wrap'}}>
        <button onClick={genMail} disabled={loading} className="cyber-btn">{loading?'GENERATING...':'Generate Ghost Mail'}</button>
        {email && <div className="glow-box" style={{flex:1,display:'flex',alignItems:'center',justifyContent:'space-between',padding:'8px 12px',minWidth:'200px'}}>
          <span style={{fontWeight:'bold',wordBreak:'break-all',fontSize:'13px'}}>{email}</span>
          <CopyBtn text={email} />
        </div>}
      </div>
      <div className="glow-box" style={{flex:1,display:'flex',flexDirection:'column',overflow:'hidden'}}>
        <div style={{background:'#00FF00',color:'#000',fontWeight:'bold',padding:'8px 12px',fontSize:'11px',display:'flex',justifyContent:'space-between'}}>
          <span>INBOX {email?'[LIVE]':'[STANDBY]'}</span>
          <span style={{animation:'pulse 2s infinite'}}>AUTO-REFRESH: 5s</span>
        </div>
        <div style={{padding:'12px',flex:1,overflow:'auto'}}>
          {msgs.length===0 ? <p style={{opacity:0.3,textAlign:'center',marginTop:'32px'}}>AWAITING INCOMING TRANSMISSIONS...</p>
          : msgs.map(m => (
            <div key={m.id} style={{borderBottom:'1px solid #003300',padding:'10px 0'}}>
              <p style={{fontSize:'10px',opacity:0.5}}>FROM: {sanitize(m.from)} | {m.date}</p>
              <p style={{fontWeight:'bold',marginTop:'4px',fontSize:'13px'}}>SUBJ: {sanitize(m.subject)}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

/* =============================================
   5. MEDIA TOOLS
============================================= */
function MediaTools() {
  const [stripped, setStripped] = useState(null);
  const [sname, setSname] = useState('');
  const [recording, setRecording] = useState(false);
  const wRef = useRef(null);
  const handleExif = async(e)=>{ const f=e.target.files[0]; if(!f)return; playBeep(500,50); const c=await stripExif(f); setStripped(URL.createObjectURL(c)); setSname('GHOST_'+f.name); playBeep(1000,100,'sine'); };
  const startMic = async()=>{
    try{
      const s=await navigator.mediaDevices.getUserMedia({audio:true}); setRecording(true); playBeep(600,80);
      const ctx=new(window.AudioContext||window.webkitAudioContext)(); const src=ctx.createMediaStreamSource(s);
      const an=ctx.createAnalyser(); an.fftSize=2048; src.connect(an);
      const buf=an.frequencyBinCount; const data=new Uint8Array(buf);
      const cv=wRef.current; const cc=cv.getContext('2d');
      const draw=()=>{requestAnimationFrame(draw);an.getByteTimeDomainData(data);
        cc.fillStyle='rgba(0,0,0,0.3)';cc.fillRect(0,0,cv.width,cv.height);
        cc.lineWidth=2;cc.strokeStyle='#00FF00';cc.shadowColor='#00FF00';cc.shadowBlur=15;cc.beginPath();
        const sw=cv.width/buf;let x=0;
        for(let i=0;i<buf;i++){const v=data[i]/128;const y=v*cv.height/2;i===0?cc.moveTo(x,y):cc.lineTo(x,y);x+=sw;}
        cc.lineTo(cv.width,cv.height/2);cc.stroke();cc.shadowBlur=0;};
      draw();
    }catch(e){alert('Microphone access denied.');}
  };
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', gap:'12px', padding:'4px' }}>
      <SectionHeader icon={ShieldAlert} title="MEDIA SECURITY TOOLS" subtitle="LOCAL PROCESSING ONLY" />
      <div className="glow-box" style={{padding:'16px'}}>
        <h3 style={{fontSize:'14px',fontWeight:'bold',marginBottom:'10px',display:'flex',alignItems:'center',gap:'8px'}}><ShieldAlert size={16}/> EXIF ANONYMIZER</h3>
        <input type="file" accept="image/jpeg,image/jpg" onChange={handleExif} id="exif2" style={{display:'none'}} />
        <div style={{display:'flex',gap:'10px',alignItems:'center',flexWrap:'wrap'}}>
          <label htmlFor="exif2" className="cyber-btn" style={{cursor:'pointer'}}>Upload Photo (JPG)</label>
          {stripped && <><span style={{color:'#00ffff',fontWeight:'bold',fontSize:'11px'}}>TRACKING CLEARED</span>
          <a href={stripped} download={sname} className="cyber-btn cyber-btn-cyan" style={{textDecoration:'none'}}><Download size={12}/>Download</a></>}
        </div>
      </div>
      <div className="glow-box" style={{padding:'16px',flex:1,display:'flex',flexDirection:'column'}}>
        <h3 style={{fontSize:'14px',fontWeight:'bold',marginBottom:'10px',display:'flex',alignItems:'center',gap:'8px'}}><Volume2 size={16}/> FREQ SCRAMBLER</h3>
        <button onClick={startMic} className="cyber-btn" disabled={recording} style={{alignSelf:'flex-start',marginBottom:'10px'}}><Mic size={12}/>{recording?'MIC ACTIVE':'Start Mic'}</button>
        <div style={{flex:1,background:'#000',border:'1px solid #003300',position:'relative',minHeight:'100px'}}>
          <canvas ref={wRef} width={600} height={100} style={{width:'100%',height:'100%'}} />
        </div>
      </div>
    </div>
  );
}

/* =============================================
   6. ZERO-KNOWLEDGE VAULT
============================================= */
function ZeroVault() {
  const [pin,setPin]=useState(''); const [cpin,setCpin]=useState(''); const [locked,setLocked]=useState(true);
  const [isNew,setIsNew]=useState(true); const [data,setData]=useState(''); const [sPin,setSPin]=useState('');
  const [show,setShow]=useState(false); const [err,setErr]=useState(''); const [saved,setSaved]=useState(false);
  useEffect(()=>{if(sessionStorage.getItem('vd'))setIsNew(false);},[]);
  const create=()=>{if(pin.length!==4){setErr('PIN must be 4 digits');return;} if(pin!==cpin){setErr('PINs do not match');return;} setSPin(pin);setLocked(false);setErr('');playBeep(1000,100,'sine');};
  const unlock=async()=>{if(pin.length!==4){setErr('PIN must be 4 digits');return;} const enc=sessionStorage.getItem('vd'); if(enc){const d=await decryptData(pin,enc);if(d===null){setErr('WRONG PIN');playBeep(200,200);return;}setData(d);} setSPin(pin);setLocked(false);setErr('');playBeep(1000,100,'sine');};
  const save=async()=>{const enc=await encryptData(sPin,sanitize(data));sessionStorage.setItem('vd',enc);setSaved(true);playBeep(800,80,'sine');setTimeout(()=>setSaved(false),2000);};
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Lock} title="ZERO-KNOWLEDGE VAULT" subtitle="AES-256-GCM ENCRYPTED" />
      {locked ? (
        <div className="glow-box" style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',padding:'32px',textAlign:'center'}}>
          <Lock size={48} style={{marginBottom:'16px'}} />
          <p style={{fontWeight:'bold',marginBottom:'4px'}}>{isNew?'CREATE VAULT PIN':'ENTER VAULT PIN'}</p>
          <p style={{fontSize:'10px',opacity:0.4,marginBottom:'20px'}}>AES-256-GCM encrypted. Vanishes on window close.</p>
          {err && <p style={{color:'#ff0040',fontSize:'11px',marginBottom:'10px'}}>{err}</p>}
          <div style={{display:'flex',flexDirection:'column',gap:'10px',width:'100%',maxWidth:'220px'}}>
            <div style={{position:'relative'}}><input type={show?'text':'password'} maxLength={4} placeholder="4-DIGIT PIN" className="cyber-input" style={{textAlign:'center',fontSize:'24px',letterSpacing:'1em',paddingRight:'36px'}} value={pin} onChange={e=>setPin(e.target.value.replace(/\D/g,''))} />
              <button onClick={()=>setShow(!show)} style={{position:'absolute',right:'8px',top:'50%',transform:'translateY(-50%)',background:'none',border:'none',color:'#00FF00',cursor:'pointer'}}>{show?<EyeOff size={14}/>:<Eye size={14}/>}</button></div>
            {isNew && <input type={show?'text':'password'} maxLength={4} placeholder="CONFIRM" className="cyber-input" style={{textAlign:'center',fontSize:'24px',letterSpacing:'1em'}} value={cpin} onChange={e=>setCpin(e.target.value.replace(/\D/g,''))} />}
            <button onClick={isNew?create:unlock} className="cyber-btn" style={{padding:'12px'}}>{isNew?'CREATE VAULT':'UNLOCK'}</button>
          </div>
        </div>
      ) : (
        <div style={{flex:1,display:'flex',flexDirection:'column',gap:'10px'}}>
          <div style={{background:'#00FF00',color:'#000',padding:'8px 12px',fontWeight:'bold',fontSize:'11px',display:'flex',justifyContent:'space-between',flexWrap:'wrap'}}>
            <span>VAULT: DECRYPTED</span><span>DATA VANISHES ON CLOSE</span>
          </div>
          <textarea className="cyber-input" style={{flex:1,resize:'none',minHeight:'150px'}} placeholder="Enter classified data..." value={data} onChange={e=>setData(sanitize(e.target.value))} />
          <button onClick={save} className="cyber-btn cyber-btn-cyan" style={{padding:'12px'}}>{saved?'ENCRYPTED & SAVED':'ENCRYPT & SAVE'}</button>
        </div>
      )}
    </div>
  );
}

/* =============================================
   7. CRYPTO ENGINE
============================================= */
function CryptoEngine() {
  const [input,setInput]=useState(''); const [h,setH]=useState({b64:'',sha:'',rot:'',bin:'',hex:'',oct:''});
  useEffect(()=>{(async()=>{const c=sanitize(input);if(!c){setH({b64:'',sha:'',rot:'',bin:'',hex:'',oct:''});return;}
    setH({b64:toBase64(c),sha:await generateSHA256(c),rot:rot13(c),bin:textToBinary(c),hex:textToHex(c),oct:textToOctal(c)});})();},[input]);
  const rows = [
    {title:'BASE64',value:h.b64,color:'#00FF00'},{title:'SHA-256',value:h.sha,color:'#00ffaa'},
    {title:'ROT13',value:h.rot,color:'#00ffff'},{title:'BINARY',value:h.bin,color:'#ffaa00'},
    {title:'HEX',value:h.hex,color:'#ff00ff'},{title:'OCTAL',value:h.oct,color:'#aaaaff'},
  ];
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Hash} title="CRYPTO CIPHER ENGINE" subtitle="REAL-TIME ENCODING & HASHING" />
      <textarea className="cyber-input" style={{height:'70px',resize:'none',marginBottom:'12px'}} placeholder="Type any string to hash and encode in real-time..." value={input} onChange={e=>setInput(sanitize(e.target.value))} />
      <div style={{display:'flex',flexDirection:'column',gap:'8px',overflow:'auto',flex:1}}>
        {rows.map(r=>(
          <div key={r.title} className="glow-box" style={{padding:'10px',display:'flex',alignItems:'center',gap:'10px',flexWrap:'wrap'}}>
            <div style={{width:'70px',fontWeight:'bold',fontSize:'11px',color:r.color,flexShrink:0}}>{r.title}</div>
            <div style={{flex:1,background:'#000',padding:'6px 8px',border:'1px solid #001a00',fontSize:'11px',wordBreak:'break-all',minWidth:'100px',minHeight:'20px'}}>{r.value||'...'}</div>
            <CopyBtn text={r.value} />
          </div>
        ))}
      </div>
    </div>
  );
}

/* =============================================
   8. PASSWORD FORTRESS (NEW)
============================================= */
function PasswordGen() {
  const [len,setLen]=useState(20); const [pw,setPw]=useState(''); const [str,setStr]=useState(null);
  const [opts,setOpts]=useState({upper:true,lower:true,numbers:true,symbols:true});
  const [history,setHistory]=useState([]);
  const gen=()=>{const p=generatePassword(len,opts);setPw(p);setStr(getPasswordStrength(p));setHistory(h=>[p,...h].slice(0,5));playBeep(800,60,'sine');};
  useEffect(()=>{gen();},[]);
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={KeyRound} title="PASSWORD FORTRESS" subtitle="CRYPTOGRAPHIC RANDOM GENERATOR" />
      <div className="glow-box" style={{padding:'16px',marginBottom:'12px'}}>
        <div style={{display:'flex',gap:'8px',marginBottom:'12px',alignItems:'center',flexWrap:'wrap'}}>
          <span style={{fontSize:'11px'}}>LENGTH: {len}</span>
          <input type="range" min={8} max={64} value={len} onChange={e=>setLen(+e.target.value)} style={{flex:1,accentColor:'#00FF00',minWidth:'100px'}} />
        </div>
        <div style={{display:'flex',gap:'8px',marginBottom:'16px',flexWrap:'wrap'}}>
          {Object.entries(opts).map(([k,v])=>(
            <button key={k} onClick={()=>setOpts(o=>({...o,[k]:!o[k]}))} className={v?"cyber-btn cyber-btn-cyan":"cyber-btn"} style={{padding:'4px 10px',fontSize:'10px',textTransform:'uppercase'}}>{k}</button>
          ))}
        </div>
        <button onClick={gen} className="cyber-btn" style={{width:'100%',padding:'12px',marginBottom:'12px'}}>GENERATE PASSWORD</button>
        {pw && (
          <div style={{background:'#000',border:'1px solid #00ffff',padding:'12px',wordBreak:'break-all',fontSize:'16px',fontWeight:'bold',letterSpacing:'1px',display:'flex',alignItems:'center',justifyContent:'space-between',gap:'8px',flexWrap:'wrap'}}>
            <span style={{flex:1,color:'#00ffff'}}>{pw}</span>
            <CopyBtn text={pw} />
          </div>
        )}
        {str && (
          <div style={{marginTop:'10px'}}>
            <div style={{display:'flex',justifyContent:'space-between',fontSize:'11px',marginBottom:'4px'}}>
              <span>STRENGTH:</span><span style={{color:str.color,fontWeight:'bold'}}>{str.label}</span>
            </div>
            <div style={{width:'100%',height:'6px',background:'#001a00',borderRadius:'3px'}}>
              <div style={{height:'100%',background:str.color,width:`${str.percent}%`,borderRadius:'3px',transition:'all 0.3s',boxShadow:`0 0 8px ${str.color}`}} />
            </div>
          </div>
        )}
      </div>
      {history.length>1 && (
        <div className="glow-box" style={{padding:'10px',overflow:'auto',flex:1}}>
          <p style={{fontSize:'10px',opacity:0.5,marginBottom:'8px'}}>RECENT GENERATIONS:</p>
          {history.slice(1).map((p,i)=><div key={i} style={{fontSize:'11px',padding:'4px 0',borderBottom:'1px solid #001a00',wordBreak:'break-all',opacity:0.6}}>{p}</div>)}
        </div>
      )}
    </div>
  );
}

/* =============================================
   9. MORSE CODE ENGINE (NEW)
============================================= */
function MorseEngine() {
  const [input,setInput]=useState(''); const [mode,setMode]=useState('encode');
  const result = mode==='encode' ? textToMorse(sanitize(input)) : morseToText(sanitize(input));
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Radio} title="MORSE CODE ENGINE" subtitle="ENCODE & DECODE" />
      <div style={{display:'flex',gap:'8px',marginBottom:'12px'}}>
        <button onClick={()=>{setMode('encode');setInput('');}} className={mode==='encode'?"cyber-btn cyber-btn-cyan":"cyber-btn"}>TEXT TO MORSE</button>
        <button onClick={()=>{setMode('decode');setInput('');}} className={mode==='decode'?"cyber-btn cyber-btn-cyan":"cyber-btn"}>MORSE TO TEXT</button>
      </div>
      <textarea className="cyber-input" style={{height:'80px',resize:'none',marginBottom:'12px'}} placeholder={mode==='encode'?'Type text to encode...':'Enter morse code (dots and dashes, space-separated)...'} value={input} onChange={e=>setInput(sanitize(e.target.value))} />
      <div className="glow-box" style={{flex:1,padding:'16px',overflow:'auto'}}>
        <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:'8px'}}>
          <span style={{fontSize:'11px',opacity:0.5}}>OUTPUT:</span>
          <CopyBtn text={result} />
        </div>
        <div style={{fontSize:'16px',fontWeight:'bold',wordBreak:'break-all',letterSpacing:mode==='encode'?'3px':'1px',color:'#00ffff',lineHeight:2}}>{result||'...'}</div>
      </div>
    </div>
  );
}

/* =============================================
   10. IP INTEL (NEW)
============================================= */
function IpIntel() {
  const [info,setInfo]=useState(null); const [loading,setLoading]=useState(false);
  const lookup=async()=>{setLoading(true);playBeep(500,60);
    try{const r=await fetch('https://ipapi.co/json/');setInfo(await r.json());playBeep(1000,80,'sine');}catch(e){setInfo({error:'LOOKUP FAILED'});}
    setLoading(false);};
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Globe} title="IP INTELLIGENCE" subtitle="NETWORK RECONNAISSANCE" />
      <button onClick={lookup} disabled={loading} className="cyber-btn" style={{marginBottom:'16px',padding:'14px'}}>{loading?'SCANNING NETWORK...':'RUN IP LOOKUP'}</button>
      {info && !info.error && (
        <div className="glow-box" style={{flex:1,padding:'16px',overflow:'auto'}}>
          {[
            ['IP ADDRESS', info.ip], ['CITY', info.city], ['REGION', info.region],
            ['COUNTRY', info.country_name], ['ISP', info.org], ['ASN', info.asn],
            ['TIMEZONE', info.timezone], ['LATITUDE', info.latitude], ['LONGITUDE', info.longitude],
          ].map(([k,v]) => (
            <div key={k} style={{display:'flex',justifyContent:'space-between',padding:'8px 0',borderBottom:'1px solid #001a00',fontSize:'12px'}}>
              <span style={{opacity:0.5}}>{k}</span>
              <span style={{fontWeight:'bold',color:'#00ffff',textAlign:'right'}}>{String(v)}</span>
            </div>
          ))}
        </div>
      )}
      {info?.error && <p style={{color:'#ff0040'}}>{info.error}</p>}
    </div>
  );
}

/* =============================================
   MAIN APP
============================================= */
export default function App() {
  const [booted, setBooted] = useState(false);
  const [tab, setTab] = useState('core');
  const [panic, setPanic] = useState(false);
  const [sidebar, setSidebar] = useState(false);

  if (!booted) return <BootSequence onComplete={() => setBooted(true)} />;
  if (panic) return <PanicScreen onExit={() => setPanic(false)} />;

  const tabs = [
    { id:'core', name:'CORE-AI', icon:Cpu, color:'#00FF00' },
    { id:'image', name:'IMG-GEN', icon:Zap, color:'#00ffaa' },
    { id:'tunnel', name:'P2P-TUNNEL', icon:Radio, color:'#00ffff' },
    { id:'inbox', name:'GHOST-MAIL', icon:Mail, color:'#00FF00' },
    { id:'media', name:'MEDIA-STRIP', icon:ShieldAlert, color:'#ffaa00' },
    { id:'vault', name:'ZERO-VAULT', icon:Lock, color:'#ff00ff' },
    { id:'crypto', name:'CIPHER-SYS', icon:Hash, color:'#00ffff' },
    { id:'password', name:'PASS-GEN', icon:KeyRound, color:'#00ffaa' },
    { id:'morse', name:'MORSE-CODE', icon:Terminal, color:'#aaaaff' },
    { id:'ipintel', name:'IP-INTEL', icon:Globe, color:'#ffaa00' },
  ];

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100vh', background:'#000', color:'#00FF00', fontFamily:"'Courier New', monospace", overflow:'hidden' }}>
      <MatrixRain />
      <div className="scanlines" />

      {/* HEADER */}
      <div style={{ position:'relative', zIndex:20, display:'flex', alignItems:'center', justifyContent:'space-between', padding:'8px 12px', borderBottom:'1px solid #00FF00', background:'rgba(0,0,0,0.95)', boxShadow:'0 2px 20px rgba(0,255,0,0.1)' }}>
        <div style={{display:'flex',alignItems:'center',gap:'10px'}}>
          <button onClick={()=>{setSidebar(!sidebar);playBeep(600,40);}} style={{background:'none',border:'1px solid #00FF00',color:'#00FF00',padding:'4px 8px',cursor:'pointer',fontFamily:'inherit',fontSize:'16px'}}>&#9776;</button>
          <div>
            <span style={{fontWeight:'bold',letterSpacing:'4px',fontSize:'16px'}} className="glow">SYS.CORE</span>
            <span style={{fontSize:'9px',opacity:0.4,marginLeft:'8px'}}>v9.9.9 [ARMED]</span>
          </div>
        </div>
        <div style={{display:'flex',alignItems:'center',gap:'12px'}}>
          <SystemStats />
          <button onClick={()=>{setPanic(true);playBeep(200,100);}} style={{background:'none',border:'none',color:'#ff0040',cursor:'pointer',padding:'4px'}} title="PANIC"><Skull size={20}/></button>
        </div>
      </div>

      <div style={{display:'flex',flex:1,overflow:'hidden',position:'relative',zIndex:10}}>
        {/* SIDEBAR OVERLAY */}
        {sidebar && <div onClick={()=>setSidebar(false)} style={{position:'fixed',inset:0,background:'rgba(0,0,0,0.8)',zIndex:29}} />}
        <div style={{
          position:'fixed', left:0, top:0, bottom:0,
          width: sidebar?'200px':'0', overflow:'hidden',
          background:'rgba(0,3,0,0.98)', borderRight:sidebar?'1px solid #00FF00':'none',
          transition:'width 0.25s ease', zIndex:30, paddingTop:sidebar?'50px':'0',
          boxShadow:sidebar?'5px 0 30px rgba(0,255,0,0.15)':'none',
        }}>
          {tabs.map(t => (
            <button key={t.id} onClick={()=>{setTab(t.id);setSidebar(false);playBeep(700,30);}}
              style={{
                display:'flex',alignItems:'center',gap:'10px',padding:'12px 16px',width:'100%',
                background:tab===t.id?'rgba(0,255,0,0.15)':'transparent',
                color:tab===t.id?t.color:'#00FF00',
                border:'none',borderBottom:'1px solid #001a00',borderLeft:tab===t.id?`3px solid ${t.color}`:'3px solid transparent',
                cursor:'pointer',fontFamily:'inherit',fontSize:'12px',
                fontWeight:tab===t.id?'bold':'normal',textAlign:'left',whiteSpace:'nowrap',
                transition:'all 0.2s',
              }}>
              <t.icon size={14}/>{t.name}
            </button>
          ))}
        </div>

        {/* MAIN CONTENT */}
        <div style={{flex:1,padding:'12px',overflow:'auto',position:'relative'}}>
          {tab==='core'&&<CoreAI/>}{tab==='image'&&<ImageGen/>}{tab==='tunnel'&&<P2PTunnel/>}
          {tab==='inbox'&&<GhostInbox/>}{tab==='media'&&<MediaTools/>}{tab==='vault'&&<ZeroVault/>}
          {tab==='crypto'&&<CryptoEngine/>}{tab==='password'&&<PasswordGen/>}
          {tab==='morse'&&<MorseEngine/>}{tab==='ipintel'&&<IpIntel/>}
        </div>
      </div>

      {/* FOOTER */}
      <div style={{position:'relative',zIndex:20,borderTop:'1px solid #003300',padding:'4px 12px',fontSize:'9px',opacity:0.3,background:'rgba(0,0,0,0.95)',textAlign:'center',letterSpacing:'1px'}}>
        CYBER TERMINAL v9.9.9 | ZERO CLOUD | ZERO LOGS | ALL LOCAL
      </div>

      {/* GLOBAL ANIMATIONS */}
      <style>{`
        @keyframes pulse{0%,100%{opacity:1}50%{opacity:0.4}}
        @keyframes blink{0%,100%{opacity:1}50%{opacity:0}}
        @keyframes glitch1{0%,100%{transform:translate(0)}20%{transform:translate(-2px,1px)}40%{transform:translate(2px,-1px)}60%{transform:translate(-1px,2px)}80%{transform:translate(1px,-2px)}}
      `}</style>
    </div>
  );
}
'@ | Set-Content "src\App.jsx" -Encoding UTF8
Write-Host "[4/4] Created App.jsx (HOLLYWOOD EDITION)" -ForegroundColor Green

# --- Update index.html ---
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
    <style>body{background:#000;margin:0;overflow:hidden}</style>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@ | Set-Content "index.html" -Encoding UTF8

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " HOLLYWOOD EDITION BUILD COMPLETE!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " NEW FEATURES ADDED:" -ForegroundColor Green
Write-Host "  + Boot Sequence Animation" -ForegroundColor Yellow
Write-Host "  + Matrix Rain Background" -ForegroundColor Yellow
Write-Host "  + CRT Scanline Overlay" -ForegroundColor Yellow
Write-Host "  + Glitch Text Effects" -ForegroundColor Yellow
Write-Host "  + Sound Effects Engine" -ForegroundColor Yellow
Write-Host "  + Live System Stats Bar" -ForegroundColor Yellow
Write-Host "  + Password Fortress Generator" -ForegroundColor Yellow
Write-Host "  + Morse Code Engine" -ForegroundColor Yellow
Write-Host "  + IP Intelligence Lookup" -ForegroundColor Yellow
Write-Host "  + Upgraded Crypto (Binary/Hex/Octal)" -ForegroundColor Yellow
Write-Host ""
Write-Host " Run: npm run dev" -ForegroundColor Cyan
Write-Host " Open: http://localhost:5173" -ForegroundColor Cyan
Write-Host ""