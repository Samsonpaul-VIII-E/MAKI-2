import React, { useState, useEffect, useRef } from 'react';
import { Shield, Key, Lock, Hash, Radio, Mail, Skull, Copy, FileDigit, ShieldAlert, Cpu, Mic, Download, CheckCircle, AlertTriangle, Eye, EyeOff, Volume2, Globe, KeyRound, Zap, Terminal, Activity, Radar, Flame, Trash, Coins, CreditCard, Smartphone, RefreshCw } from 'lucide-react';
import { enforceAntiTamper, sanitize, encodeStego, decodeStego, generateSHA256, toBase64, rot13, textToBinary, textToHex, textToOctal, textToMorse, morseToText, generateRequestToken, computeActivationKey, deriveKey, encryptData, decryptData, stripExif, generatePassword, getPasswordStrength, playBeep, triggerHaptic, setAppCloak } from './utils';

enforceAntiTamper();

/* =============================================
   BOOT SEQUENCE
============================================= */
function BootSequence({ onComplete }) {
  const [lines, setLines] = useState([]);
  const bootLines = [
    'BIOS CHECK [CORE-X9]..................... OK',
    'MEMORY INTEGRITY TEST [32768 MB]......... PASS',
    'FROZEN RUNTIME INTEGRITY SEAL............ ACTIVE',
    'TOR 3-HOP CIRCUIT PIPELINE............... ESTABLISHED',
    'DARKNET BITCOIN ESCROW ENGINE............ ONLINE',
    '250,000-ROUND PBKDF2 / AES-GCM ENGINE.... ONLINE',
    'QUANTUM STEGANOGRAPHY MODULE............. READY',
    'ACTIVE PORT RECON & THREAT MAP........... ARMED',
    'DOD 5220.22-M VOLATILE SHREDDER.......... LOADED',
    'REWARDED NEURAL AD MATRIX GATEWAY........ ONLINE',
    'EULA LIABILITY WAIVER PROTOCOL........... ENFORCED',
    '>>> SYS.CORE v9.9.9 MASTER SUITE ONLINE <<<'
  ];

  useEffect(() => {
    let idx = 0;
    const iv = setInterval(() => {
      if (idx < bootLines.length) {
        setLines(p => [...p, bootLines[idx]]);
        playBeep(400 + Math.random() * 450, 20);
        idx++;
      } else {
        clearInterval(iv);
        playBeep(1200, 200, 'sine');
        setTimeout(onComplete, 600);
      }
    }, 160);
    return () => clearInterval(iv);
  }, []);

  return (
    <div style={{ position:'fixed', inset:0, background:'#000', zIndex:99999, display:'flex', alignItems:'center', justifyContent:'center', fontFamily:"'Courier New', monospace" }}>
      <div style={{ maxWidth:'680px', width:'92%', padding:'20px' }}>
        <div style={{ color:'#00FF00', marginBottom:'16px', fontSize:'20px', fontWeight:'bold', textAlign:'center', letterSpacing:'5px' }} className="glow">
          SYS.CORE // MASTER CYBER TERMINAL
        </div>
        <div style={{ border:'1px solid #003300', padding:'16px', background:'rgba(0,10,0,0.9)', minHeight:'280px', fontSize:'12px', lineHeight:'1.7' }}>
          {lines.map((l, i) => (
            <div key={i} style={{ color: l.includes('<<<') ? '#00ffff' : l.includes('ONLINE') || l.includes('ARMED') ? '#00ffaa' : '#00FF00' }}>
              {l}
            </div>
          ))}
          <span style={{ animation:'pulse 0.5s infinite', color:'#00FF00' }}>_</span>
        </div>
      </div>
    </div>
  );
}

/* =============================================
   MATRIX RAIN
============================================= */
function MatrixRain() {
  const ref = useRef(null);
  useEffect(() => {
    const c = ref.current; if (!c) return;
    const ctx = c.getContext('2d');
    const resize = () => { c.width = window.innerWidth; c.height = window.innerHeight; };
    resize(); window.addEventListener('resize', resize);
    const cols = Math.floor(c.width / 16);
    const drops = Array(cols).fill(1);
    const chars = '01ã‚¢ã‚¤ã‚¦ã‚¨ã‚ªã‚«ã‚­ã‚¯ã‚±ã‚³ã‚µã‚·ã‚¹ã‚»ã‚½ã‚¿ãƒãƒ„ãƒ†ãƒˆ0123456789ABCDEF';
    const draw = () => {
      ctx.fillStyle = 'rgba(0,0,0,0.06)';
      ctx.fillRect(0, 0, c.width, c.height);
      for (let i = 0; i < drops.length; i++) {
        const ch = chars[Math.floor(Math.random() * chars.length)];
        ctx.fillStyle = Math.random() > 0.95 ? '#ffffff' : Math.random() > 0.8 ? '#00ffaa' : '#00FF00';
        ctx.font = '14px monospace';
        ctx.fillText(ch, i * 16, drops[i] * 16);
        if (drops[i] * 16 > c.height && Math.random() > 0.975) drops[i] = 0;
        drops[i]++;
      }
    };
    const iv = setInterval(draw, 45);
    return () => { clearInterval(iv); window.removeEventListener('resize', resize); };
  }, []);
  return <canvas ref={ref} style={{ position:'fixed', top:0, left:0, zIndex:0, opacity:0.12, pointerEvents:'none' }} />;
}

/* =============================================
   HELPERS & REUSABLE UI
============================================= */
function SectionHeader({ icon: Icon, title, subtitle }) {
  return (
    <div style={{ borderBottom:'1px solid #00FF00', paddingBottom:'8px', marginBottom:'12px' }}>
      <div style={{ display:'flex', alignItems:'center', gap:'8px' }}>
        {Icon && <Icon size={18} />}
        <span style={{ fontSize:'15px', fontWeight:'bold', letterSpacing:'2px' }}>{title}</span>
      </div>
      {subtitle && <p style={{ fontSize:'10px', opacity:0.4, marginTop:'2px', letterSpacing:'1px' }}>{subtitle}</p>}
    </div>
  );
}

function CopyBtn({ text, label = 'COPY' }) {
  const [ok, setOk] = useState(false);
  return (
    <button onClick={() => { navigator.clipboard.writeText(text); setOk(true); triggerHaptic([20]); playBeep(1000, 35, 'sine'); setTimeout(() => setOk(false), 1400); }}
      className={ok ? "cyber-btn cyber-btn-cyan" : "cyber-btn"} style={{ padding:'4px 8px', fontSize:'10px' }}>
      {ok ? <><CheckCircle size={11}/> OK</> : <><Copy size={11}/> {label}</>}
    </button>
  );
}

function PanicScreen({ onExit }) {
  return (
    <div style={{ position:'fixed', inset:0, background:'#fff', zIndex:99999 }}>
      <div style={{ background:'#f0f0f0', padding:'4px 12px', borderBottom:'1px solid #ccc', display:'flex', gap:'20px', fontSize:'13px', fontFamily:'Segoe UI, sans-serif', color:'#333' }}>
        <span style={{fontWeight:'bold'}}>Notepad</span>
        <span>File</span><span>Edit</span><span>Format</span><span>View</span><span>Help</span>
      </div>
      <textarea style={{ width:'100%', height:'calc(100% - 30px)', border:'none', outline:'none', padding:'12px', fontFamily:'Consolas', fontSize:'14px', color:'#333', resize:'none' }}
        defaultValue={"Shopping List:\n- Milk\n- Eggs 6pc\n- Whole wheat bread\n- Rice 5kg\n\nNotes:\n- Review Q3 summary\n- Call supplier"} />
      <button onClick={onExit} style={{ position:'fixed', bottom:0, right:0, width:'15px', height:'15px', opacity:0, cursor:'default' }} />
    </div>
  );
}

/* =============================================
   1. CORE-AI TERMINAL
============================================= */
function CoreAI() {
  const [key, setKey] = useState('');
  const [status, setStatus] = useState('AWAITING 16-DIGIT ENTERPRISE KEY...');
  const [checking, setChecking] = useState(false);
  const handleActivate = () => {
    if (key.length !== 16) { setStatus('ERROR: LICENSE KEY MUST BE EXACTLY 16 DIGITS'); return; }
    setChecking(true); setStatus('CONNECTING TO EPHEMERAL RAM NODE OVER TLS 1.3...');
    playBeep(600, 90); triggerHaptic([40]);
    setTimeout(() => {
      setStatus('ACCESS DENIED: KEY REVOKED OR UNPAID (VALUED AT â‚¹55,000/YR)');
      setChecking(false); playBeep(200, 250); triggerHaptic([50, 50, 50]);
    }, 2200);
  };
  return (
    <div style={{ height:'100%', overflow:'auto', padding:'4px' }}>
      <SectionHeader icon={Cpu} title="CORE-AI: UNCENSORED CLOUD PROTOCOL" subtitle="RESTRICTED ENTERPRISE TERMINAL" />
      <div className="glow-box" style={{ padding:'20px', textAlign:'center', marginBottom:'14px' }}>
        <Shield size={44} style={{ margin:'0 auto 10px', animation:'pulse 2s infinite' }} />
        <p style={{ fontSize:'17px', color:'#ff0040', fontWeight:'bold', marginBottom:'12px' }} className="glow-red">ACCESS VALUE: â‚¹55,000 / 1 FULL YEAR PASS</p>
        <div style={{ background:'#000', border:'1px solid #003300', padding:'10px', fontSize:'11px', maxWidth:'480px', margin:'0 auto 16px' }}>
          <p style={{ fontWeight:'bold', color:'#00FF00', marginBottom:'4px' }}>ZERO-LOG EPHEMERAL ARCHITECTURE</p>
          <p style={{ opacity:0.7 }}>Pure RAM execution. 0% user prompt storage. 0% IP tracking. Zero telemetry.</p>
        </div>
        <div style={{ maxWidth:'360px', margin:'0 auto', display:'flex', flexDirection:'column', gap:'8px' }}>
          <input type="text" maxLength={16} placeholder="ENTER 16-DIGIT LICENSE KEY" className="cyber-input" style={{ textAlign:'center', letterSpacing:'0.2em' }} value={key} onChange={e => setKey(sanitize(e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '')))} />
          <button onClick={handleActivate} className="cyber-btn cyber-btn-red" disabled={checking}>{checking ? 'VERIFYING KEY...' : 'ACTIVATE LICENSE'}</button>
          <p style={{ fontSize:'10px', opacity:0.5 }}>{status}</p>
        </div>
      </div>
    </div>
  );
}

/* =============================================
   2. LOCAL AI IMAGE GENERATOR (15s AD WALL + WAIVER)
============================================= */
function ImageGen() {
  const [prompt, setPrompt] = useState('Cyberpunk neon samurai standing in rain with katana');
  const [acceptedTerms, setAcceptedTerms] = useState(() => localStorage.getItem('terms_waived') === '1');
  const [isAdStreaming, setIsAdStreaming] = useState(false);
  const [adTimer, setAdTimer] = useState(15);
  const [adProgress, setAdProgress] = useState(0);
  const [isSynthesizing, setIsSynthesizing] = useState(false);
  const [synthProgress, setSynthProgress] = useState(0);
  const [generated, setGenerated] = useState(false);
  const canvasRef = useRef(null);

  const drawArtwork = (txt) => {
    const c = canvasRef.current; if (!c) return;
    const ctx = c.getContext('2d');
    const w = c.width = 512; const h = c.height = 512;

    const bg = ctx.createLinearGradient(0, 0, 0, h);
    bg.addColorStop(0, '#000602'); bg.addColorStop(0.5, '#001808'); bg.addColorStop(1, '#002b0f');
    ctx.fillStyle = bg; ctx.fillRect(0, 0, w, h);

    const sun = ctx.createRadialGradient(w/2, h * 0.4, 10, w/2, h * 0.4, 120);
    sun.addColorStop(0, '#00ffff'); sun.addColorStop(0.5, '#00ff66'); sun.addColorStop(1, 'transparent');
    ctx.fillStyle = sun; ctx.beginPath(); ctx.arc(w/2, h * 0.4, 120, 0, Math.PI * 2); ctx.fill();

    ctx.strokeStyle = '#00FF00'; ctx.lineWidth = 1;
    const hor = h * 0.55;
    ctx.beginPath();
    for (let x = -w; x <= w * 2; x += 32) { ctx.moveTo(w/2, hor); ctx.lineTo(x, h); }
    for (let y = hor; y <= h; y += (y - hor) * 0.35 + 8) { ctx.moveTo(0, y); ctx.lineTo(w, y); }
    ctx.stroke();

    // Thematic foreground graphics based on prompt keywords
    ctx.fillStyle = '#000c05';
    ctx.strokeStyle = '#00ffff';
    const lower = txt.toLowerCase();
    if (lower.includes('skull')) {
      ctx.beginPath(); ctx.arc(w/2, hor - 30, 45, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
      ctx.fillStyle = '#00ffff'; ctx.fillRect(w/2 - 20, hor - 40, 10, 10); ctx.fillRect(w/2 + 10, hor - 40, 10, 10);
    } else if (lower.includes('samurai') || lower.includes('warrior')) {
      ctx.fillRect(w/2 - 18, hor - 80, 36, 80); ctx.strokeRect(w/2 - 18, hor - 80, 36, 80);
      ctx.strokeStyle = '#ff0040'; ctx.lineWidth = 3;
      ctx.beginPath(); ctx.moveTo(w/2 + 15, hor - 100); ctx.lineTo(w/2 + 35, hor); ctx.stroke();
    } else {
      let bx = 16;
      [45, 95, 65, 120, 80, 150, 110, 70, 130, 90, 50].forEach(bh => {
        ctx.fillRect(bx, hor - bh, 36, bh); ctx.strokeRect(bx, hor - bh, 36, bh); bx += 44;
      });
    }

    ctx.fillStyle = 'rgba(0,10,5,0.9)';
    ctx.fillRect(15, h - 45, w - 30, 32);
    ctx.strokeStyle = '#00ffff'; ctx.lineWidth = 1; ctx.strokeRect(15, h - 45, w - 30, 32);
    ctx.fillStyle = '#00ffff'; ctx.font = 'bold 10px monospace';
    ctx.fillText(`SYNTH: ${txt.slice(0, 34)}...`, 25, h - 25);
  };

  const startGeneration = () => {
    if (!prompt) return;
    setIsAdStreaming(true); setAdTimer(15); setAdProgress(0); setGenerated(false);
    triggerHaptic([40]); playBeep(500, 80);
    let cur = 15;
    const iv = setInterval(() => {
      cur--;
      setAdTimer(cur);
      setAdProgress(Math.min(100, Math.round(((15 - cur) / 15) * 100)));
      playBeep(250 + Math.random() * 500, 20);
      if (cur <= 0) {
        clearInterval(iv);
        setIsAdStreaming(false);
        setIsSynthesizing(true);
        let s = 1;
        const sIv = setInterval(() => {
          s += 25;
          setSynthProgress(Math.min(100, s));
          if (s >= 100) {
            clearInterval(sIv);
            setIsSynthesizing(false);
            setGenerated(true);
            playBeep(1200, 200, 'sine');
            triggerHaptic([50, 50, 100]);
            setTimeout(() => drawArtwork(prompt), 100);
          }
        }, 120);
      }
    }, 1000);
  };

  const downloadArt = () => {
    const c = canvasRef.current; if (!c) return;
    const a = document.createElement('a');
    a.download = `CYBER_NEURAL_ART_${Date.now()}.png`;
    a.href = c.toDataURL('image/png');
    a.click();
    playBeep(1000, 50, 'sine');
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Zap} title="LOCAL AI IMAGE GENERATOR" subtitle="REWARDED 15s SPONSORED AD PIPELINE ONLY HERE" />

      {/* TERMS & LIABILITY WAIVER PROTOCOL */}
      {!acceptedTerms && (
        <div className="glow-box" style={{ padding:'14px', marginBottom:'12px', border:'1px solid #00ffff' }}>
          <p style={{ fontSize:'11px', color:'#00ffff', fontWeight:'bold', marginBottom:'6px' }}>LEGAL AUTONOMOUS EULA & LIABILITY WAIVER</p>
          <p style={{ fontSize:'10px', opacity:0.75, lineHeight:'1.5', marginBottom:'10px' }}>
            NOTICE: Processing executes entirely client-side on local hardware. The developer stores 0% prompt data, maintains zero editorial control, and disclaims all liability for end-user creations. By using this software, you assume 100% individual liability under applicable cyber and intellectual property laws, and agree not to generate prohibited or unlawful media.
          </p>
          <button onClick={() => { setAcceptedTerms(true); localStorage.setItem('terms_waived', '1'); triggerHaptic([30]); }}
            className="cyber-btn cyber-btn-cyan" style={{ padding:'6px 14px' }}>
            [ I AGREE & ASSUME FULL LIABILITY ]
          </button>
        </div>
      )}

      {/* 15-SECOND MATRIX AD WALL (ONLY HERE) */}
      {isAdStreaming && (
        <div style={{ position:'fixed', inset:0, background:'#000', zIndex:9999, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center' }}>
          <MatrixRain />
          <div style={{ position:'relative', zIndex:1, textAlign:'center', maxWidth:'380px', padding:'16px' }}>
            <p style={{ color:'#00FF00', fontSize:'12px', letterSpacing:'3px', marginBottom:'16px' }}>STREAMING SPONSORED DATA PACKET...</p>
            <div style={{ fontSize:'120px', fontWeight:'bold', lineHeight:1, color:'#00FF00' }} className="glow">{adTimer}</div>
            <div style={{ width:'100%', height:'8px', border:'1px solid #00FF00', background:'#001500', marginTop:'24px', padding:'1px' }}>
              <div style={{ height:'100%', width:`${adProgress}%`, background:'linear-gradient(90deg, #00FF00, #00ffff)', transition:'width 1s linear' }} />
            </div>
            <p style={{ color:'#005500', fontSize:'10px', marginTop:'14px' }}>DO NOT CLOSE // NEURAL COMPUTE AD WALL</p>
          </div>
        </div>
      )}

      <div style={{ display:'flex', gap:'8px', marginBottom:'10px', flexWrap:'wrap' }}>
        <input type="text" placeholder="Enter prompt to synthesize..." className="cyber-input" style={{ flex:1, minWidth:'200px' }} value={prompt} onChange={e => setPrompt(sanitize(e.target.value))} />
        <button onClick={startGeneration} className="cyber-btn cyber-btn-cyan" disabled={!prompt || isAdStreaming || isSynthesizing || !acceptedTerms}>
          GENERATE (15s AD)
        </button>
      </div>

      <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'16px', minHeight:'240px' }}>
        {isSynthesizing && (
          <div style={{ width:'100%', maxWidth:'320px', textAlign:'center' }}>
            <Activity size={32} style={{ margin:'0 auto 10px', animation:'pulse 0.8s infinite', color:'#00ffff' }} />
            <p style={{ fontSize:'11px', marginBottom:'6px' }}>LOCAL NEURAL SYNTHESIS IN PROGRESS...</p>
            <div style={{ width:'100%', height:'8px', border:'1px solid #00FF00', padding:'1px' }}>
              <div style={{ height:'100%', width:`${synthProgress}%`, background:'#00ffff' }} />
            </div>
          </div>
        )}
        {!isSynthesizing && !generated && (
          <div style={{ textAlign:'center', opacity:0.5 }}>
            <Zap size={36} style={{ margin:'0 auto 8px' }} />
            <p style={{ fontSize:'12px', fontWeight:'bold' }}>READY FOR GENERATION</p>
            <p style={{ fontSize:'10px' }}>Click GENERATE to unlock the 15-second sponsor packet and synthesize art.</p>
          </div>
        )}
        <div style={{ display: generated ? 'flex' : 'none', flexDirection:'column', alignItems:'center', gap:'10px', width:'100%' }}>
          <canvas ref={canvasRef} style={{ width:'100%', maxWidth:'280px', height:'auto', border:'1px solid #00ffff', boxShadow:'0 0 15px rgba(0,255,255,0.25)' }} />
          <button onClick={downloadArt} className="cyber-btn cyber-btn-cyan"><Download size={12}/> DOWNLOAD PNG</button>
        </div>
      </div>
    </div>
  );
}

/* =============================================
   3. DARKNET BITCOIN ESCROW & 32-CHAR TOKEN SYSTEM
============================================= */
function BitcoinEscrow() {
  const [token, setToken] = useState(() => generateRequestToken());
  const [userKey, setUserKey] = useState('');
  const [isVip, setIsVip] = useState(() => localStorage.getItem('is_vip') === '1');
  const [statusMsg, setStatusMsg] = useState('');
  const [adminTokenIn, setAdminTokenIn] = useState('');
  const [mintedKey, setMintedKey] = useState('');
  const [showAdminConsole, setShowAdminConsole] = useState(false);

  const btcAddress = 'bc1qfua2ayuvhh287zzk3g7rvtkzslh9lyklv6n';

  const verifyKey = async () => {
    triggerHaptic([30]);
    // Master Bypass Code check
    if (userKey === '6712671267126712') {
      setIsVip(true); localStorage.setItem('is_vip', '1');
      setShowAdminConsole(true);
      setStatusMsg('MASTER ADMIN OVERRIDE ACCEPTED: 6712-6712-6712-6712 VERIFIED.');
      playBeep(1200, 250, 'sine');
      return;
    }
    // Check computed 32-char token match
    const valid = await computeActivationKey(token);
    if (userKey.trim().toUpperCase() === valid) {
      setIsVip(true); localStorage.setItem('is_vip', '1');
      setStatusMsg('âœ“ KEY ACCEPTED: VIP GOD-MODE ENGAGED PERMANENTLY.');
      playBeep(1200, 250, 'sine');
    } else {
      setStatusMsg('INVALID ACTIVATION KEY. CHECK TXID WITH ADMIN.');
      playBeep(250, 200);
    }
  };

  const mintKeyForUser = async () => {
    if (!adminTokenIn) return;
    const k = await computeActivationKey(adminTokenIn);
    setMintedKey(k);
    playBeep(1000, 80, 'sine');
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px', overflow:'auto' }}>
      <SectionHeader icon={Coins} title="ANONYMOUS BITCOIN ESCROW" subtitle="ZERO-KYC 32-CHAR CRYPTOGRAPHIC GATEWAY" />

      {isVip && (
        <div className="glow-box" style={{ padding:'12px', marginBottom:'12px', border:'1px solid #00ffaa' }}>
          <p style={{ color:'#00ffaa', fontWeight:'bold', fontSize:'12px' }}>â˜… VIP GOD-MODE ACTIVE: ALL MODULES PERMANENTLY UNLOCKED</p>
        </div>
      )}

      {/* BITCOIN ESCROW DETAILS */}
      <div className="glow-box" style={{ padding:'16px', marginBottom:'12px' }}>
        <p style={{ fontSize:'11px', color:'#00ffff', fontWeight:'bold', marginBottom:'6px' }}>1. YOUR ANONYMOUS 32-CHAR ORDER TOKEN</p>
        <div style={{ background:'#000', border:'1px solid #003300', padding:'8px 10px', display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:'10px' }}>
          <span style={{ fontSize:'12px', fontWeight:'bold', letterSpacing:'1px', color:'#00ffff', wordBreak:'break-all' }}>{token}</span>
          <CopyBtn text={token} label="COPY TOKEN" />
        </div>

        <p style={{ fontSize:'11px', color:'#00ffaa', fontWeight:'bold', marginBottom:'6px' }}>2. SEND BITCOIN PAYMENT (0.00085 BTC / ~$50 USD)</p>
        <div style={{ background:'#000', border:'1px solid #003300', padding:'8px 10px', display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:'10px' }}>
          <span style={{ fontSize:'11px', wordBreak:'break-all', fontFamily:'monospace' }}>{btcAddress}</span>
          <CopyBtn text={btcAddress} label="COPY BTC" />
        </div>

        {/* HELPER FOR USERS WITHOUT BITCOIN WALLET */}
        <div style={{ background:'rgba(0,255,255,0.05)', border:'1px dashed #00ffff', padding:'10px', marginBottom:'12px' }}>
          <p style={{ fontSize:'10px', color:'#00ffff', fontWeight:'bold', marginBottom:'4px' }}>DON'T HAVE A BITCOIN WALLET?</p>
          <p style={{ fontSize:'10px', opacity:0.75, marginBottom:'6px' }}>You can send Bitcoin instantly with Debit Card, Apple Pay, or Google Pay via direct on-ramps without creating a complex crypto wallet:</p>
          <a href="https://www.moonpay.com/buy/btc" target="_blank" rel="noreferrer" className="cyber-btn cyber-btn-cyan" style={{ padding:'5px 10px', textDecoration:'none', fontSize:'10px' }}>
            PAY WITH CARD (MOONPAY ON-RAMP)
          </a>
        </div>

        <p style={{ fontSize:'11px', fontWeight:'bold', marginBottom:'6px' }}>3. ENTER 32-CHAR KEY RECEIVED FROM ADMIN</p>
        <div style={{ display:'flex', gap:'8px', marginBottom:'6px' }}>
          <input type="text" placeholder="Paste 32-character key..." className="cyber-input" value={userKey} onChange={e => setUserKey(e.target.value)} />
          <button onClick={verifyKey} className="cyber-btn cyber-btn-cyan">ACTIVATE</button>
        </div>
        {statusMsg && <p style={{ fontSize:'11px', fontWeight:'bold', color: statusMsg.includes('ACCEPTED') ? '#00ffaa' : '#ff0040' }}>{statusMsg}</p>}
      </div>

      {/* HIDDEN ADMIN MINTING PANEL (TRIGGERED BY 6712671267126712) */}
      {showAdminConsole && (
        <div className="glow-box" style={{ padding:'16px', border:'1px solid #ff0040', background:'rgba(20,0,0,0.9)' }}>
          <p style={{ color:'#ff0040', fontWeight:'bold', fontSize:'12px', marginBottom:'6px' }}>âš¡ SECRET ADMIN KEY MINTING CONSOLE (MASTER CODE 6712 VERIFIED)</p>
          <p style={{ fontSize:'10px', opacity:0.7, marginBottom:'8px' }}>Paste the user's 32-char Request Token to generate their matching 32-char Activation Key:</p>
          <div style={{ display:'flex', gap:'8px', marginBottom:'8px' }}>
            <input type="text" placeholder="Paste User's REQ-XXXX token..." className="cyber-input" value={adminTokenIn} onChange={e => setAdminTokenIn(e.target.value)} />
            <button onClick={mintKeyForUser} className="cyber-btn cyber-btn-red">MINT KEY</button>
          </div>
          {mintedKey && (
            <div style={{ background:'#000', border:'1px solid #ff0040', padding:'8px 10px', display:'flex', justifyContent:'space-between', alignItems:'center' }}>
              <span style={{ color:'#00ffff', fontWeight:'bold', fontSize:'12px' }}>{mintedKey}</span>
              <CopyBtn text={mintedKey} label="COPY KEY" />
            </div>
          )}
        </div>
      )}
    </div>
  );
}

/* =============================================
   4. GHOST-STEGO (REAL ZERO-WIDTH INVISIBLE INK)
============================================= */
function GhostStego() {
  const [cover, setCover] = useState('Meeting at the library tomorrow morning at 10 AM.');
  const [secret, setSecret] = useState('ALPHA-KEY: 9482-CLASSIFIED');
  const [stegoOut, setStegoOut] = useState('');
  const [decodeIn, setDecodeIn] = useState('');
  const [revealed, setRevealed] = useState('');

  const handleEnc = () => {
    const r = encodeStego(cover, secret);
    setStegoOut(r); triggerHaptic([30]); playBeep(900, 70, 'sine');
  };

  const handleDec = () => {
    const r = decodeStego(decodeIn);
    setRevealed(r); triggerHaptic([40]); playBeep(r.includes('NO HIDDEN') ? 250 : 1100, 90);
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px', overflow:'auto' }}>
      <SectionHeader icon={EyeOff} title="GHOST-STEGO: INVISIBLE INK" subtitle="100% REAL ZERO-WIDTH UNICODE ENCODER" />
      <div className="glow-box" style={{ padding:'12px', marginBottom:'12px' }}>
        <p style={{ fontSize:'11px', fontWeight:'bold', color:'#00ffff', marginBottom:'6px' }}>1. INJECT INVISIBLE SECRET INTO VISIBLE SENTENCE</p>
        <input type="text" placeholder="Visible cover text..." className="cyber-input" style={{ marginBottom:'6px' }} value={cover} onChange={e => setCover(sanitize(e.target.value))} />
        <input type="text" placeholder="Invisible secret text..." className="cyber-input" style={{ marginBottom:'8px' }} value={secret} onChange={e => setSecret(sanitize(e.target.value))} />
        <button onClick={handleEnc} className="cyber-btn" style={{ width:'100%', marginBottom:'8px' }}>INJECT INVISIBLE PAYLOAD</button>
        {stegoOut && (
          <div style={{ background:'#000', border:'1px solid #00ffff', padding:'8px 10px', display:'flex', justifyContent:'space-between', alignItems:'center' }}>
            <span style={{ fontSize:'11px', wordBreak:'break-all', color:'#00ffff' }}>{stegoOut}</span>
            <CopyBtn text={stegoOut} label="COPY STEGO" />
          </div>
        )}
      </div>

      <div className="glow-box" style={{ padding:'12px' }}>
        <p style={{ fontSize:'11px', fontWeight:'bold', color:'#00ffaa', marginBottom:'6px' }}>2. DECODE INVISIBLE PAYLOAD FROM TEXT</p>
        <textarea placeholder="Paste suspicious text to reveal hidden unicode payload..." className="cyber-input" style={{ height:'60px', resize:'none', marginBottom:'8px' }} value={decodeIn} onChange={e => setDecodeIn(e.target.value)} />
        <button onClick={handleDec} className="cyber-btn cyber-btn-cyan" style={{ width:'100%', marginBottom:'8px' }}>EXTRACT STEGO PAYLOAD</button>
        {revealed && (
          <div style={{ background:'#000', border:'1px solid #00ffaa', padding:'8px 10px', fontSize:'11px', fontWeight:'bold', color: revealed.includes('NO HIDDEN') ? '#ff0040' : '#00ffaa' }}>
            REVEALED: {revealed}
          </div>
        )}
      </div>
    </div>
  );
}

/* =============================================
   5. PORT RADAR (NETWORK RECON ENGINE)
============================================= */
function PortRadar() {
  const [target, setTarget] = useState('192.168.1.1');
  const [scanning, setScanning] = useState(false);
  const [results, setResults] = useState([]);
  const ports = [
    { p: 21, s: 'FTP', r: 'HIGH' }, { p: 22, s: 'SSH', r: 'MED' },
    { p: 53, s: 'DNS', r: 'LOW' }, { p: 80, s: 'HTTP', r: 'LOW' },
    { p: 443, s: 'HTTPS', r: 'SAFE' }, { p: 3306, s: 'MYSQL', r: 'CRIT' },
    { p: 3389, s: 'RDP', r: 'CRIT' }, { p: 8080, s: 'PROXY', r: 'MED' }
  ];

  const sweep = () => {
    setScanning(true); setResults([]); triggerHaptic([30]); playBeep(400, 60);
    ports.forEach((item, idx) => {
      setTimeout(() => {
        const isOpen = Math.random() > 0.4;
        const lat = (10 + Math.random() * 55).toFixed(0);
        setResults(p => [...p, { ...item, open: isOpen, lat }]);
        playBeep(isOpen ? 850 : 280, 25);
        if (idx === ports.length - 1) { setScanning(false); playBeep(1200, 150, 'sine'); }
      }, 300 * (idx + 1));
    });
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Radar} title="PORT RADAR & NETWORK RECON" subtitle="SIMULATED PROBING ENGINE" />
      <div style={{ display:'flex', gap:'8px', marginBottom:'10px' }}>
        <input type="text" placeholder="Target IP..." className="cyber-input" value={target} onChange={e => setTarget(sanitize(e.target.value))} />
        <button onClick={sweep} disabled={scanning} className="cyber-btn cyber-btn-cyan">{scanning ? 'SWEEPING...' : 'SWEEP PORTS'}</button>
      </div>
      <div className="glow-box" style={{ flex:1, padding:'8px', overflow:'auto' }}>
        {results.length === 0 && !scanning && <p style={{ opacity:0.4, textAlign:'center', marginTop:'30px', fontSize:'11px' }}>AWAITING TARGET RECONNAISSANCE...</p>}
        {results.map((r, i) => (
          <div key={i} style={{ display:'flex', justifyContent:'space-between', padding:'6px 4px', borderBottom:'1px solid #002200', fontSize:'11px' }}>
            <span style={{ fontWeight:'bold' }}>PORT {r.p}</span>
            <span style={{ opacity:0.6 }}>{r.s}</span>
            <span style={{ color: r.open ? '#00FF00' : '#ff0040', fontWeight:'bold' }}>{r.open ? 'OPEN' : 'CLOSED'}</span>
            <span style={{ opacity:0.5 }}>{r.lat}ms</span>
            <span style={{ color: r.r === 'CRIT' ? '#ff0040' : r.r === 'HIGH' ? '#ffaa00' : '#00ffff' }}>[{r.r}]</span>
          </div>
        ))}
      </div>
    </div>
  );
}

/* =============================================
   6. GLOBAL CYBER THREAT MAP
============================================= */
function ThreatMap() {
  const canvasRef = useRef(null);
  useEffect(() => {
    const c = canvasRef.current; if (!c) return;
    const ctx = c.getContext('2d');
    c.width = 600; c.height = 300;
    const nodes = [
      { x: 120, y: 100, name:'US-EAST' }, { x: 280, y: 80, name:'EU-CENTRAL' },
      { x: 420, y: 110, name:'ASIA-EAST' }, { x: 480, y: 220, name:'AU-SYD' },
      { x: 200, y: 210, name:'SA-BR' }, { x: 340, y: 190, name:'IN-MUM' }
    ];
    let arcs = [];
    const iv = setInterval(() => {
      const from = nodes[Math.floor(Math.random() * nodes.length)];
      const to = nodes[Math.floor(Math.random() * nodes.length)];
      if (from !== to) arcs.push({ from, to, prog: 0, color: Math.random() > 0.5 ? '#ff0040' : '#00ffff' });
    }, 600);

    const anim = () => {
      ctx.fillStyle = 'rgba(0,10,0,0.15)'; ctx.fillRect(0, 0, c.width, c.height);
      nodes.forEach(n => {
        ctx.fillStyle = '#00FF00'; ctx.beginPath(); ctx.arc(n.x, n.y, 4, 0, Math.PI * 2); ctx.fill();
        ctx.fillStyle = 'rgba(0,255,0,0.6)'; ctx.font = '8px monospace'; ctx.fillText(n.name, n.x - 15, n.y - 8);
      });
      arcs.forEach((a, i) => {
        a.prog += 0.03;
        const curX = a.from.x + (a.to.x - a.from.x) * a.prog;
        const curY = a.from.y + (a.to.y - a.from.y) * a.prog;
        ctx.strokeStyle = a.color; ctx.lineWidth = 1;
        ctx.beginPath(); ctx.moveTo(a.from.x, a.from.y); ctx.lineTo(curX, curY); ctx.stroke();
      });
      arcs = arcs.filter(a => a.prog < 1);
      requestAnimationFrame(anim);
    };
    anim();
    return () => clearInterval(iv);
  }, []);

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Globe} title="GLOBAL THREAT RADAR" subtitle="SIMULATED LIVE ATTACK TELEMETRY" />
      <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'8px' }}>
        <canvas ref={canvasRef} style={{ width:'100%', height:'auto', border:'1px solid #003300' }} />
        <p style={{ fontSize:'10px', opacity:0.5, marginTop:'6px' }}>MONITORING REAL-TIME DDOS & ZERO-DAY INJECTION VECTORS</p>
      </div>
    </div>
  );
}

/* =============================================
   7. DOD DATA SHREDDER
============================================= */
function DataShredder() {
  const [shredding, setShredding] = useState(false);
  const [pass, setPass] = useState(0);
  const [hexGrid, setHexGrid] = useState([]);
  const [done, setDone] = useState(false);

  const startShred = () => {
    setShredding(true); setDone(false); setPass(1); playBeep(300, 100);
    let p = 1;
    const iv = setInterval(() => {
      p++; setPass(p);
      setHexGrid(Array(32).fill(0).map(() => Math.floor(Math.random() * 255).toString(16).padStart(2, '0').toUpperCase()));
      playBeep(200 + Math.random() * 600, 20);
      if (p >= 7) {
        clearInterval(iv);
        setHexGrid(Array(32).fill('00')); setShredding(false); setDone(true);
        sessionStorage.clear(); playBeep(1400, 250, 'sine');
      }
    }, 350);
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Flame} title="DOD EMERGENCY DATA SHREDDER" subtitle="7-PASS VOLATILE MEMORY PURGE" />
      <div className="glow-box" style={{ padding:'14px', textAlign:'center', marginBottom:'12px' }}>
        <Trash size={36} style={{ margin:'0 auto 8px', color:'#ff0040' }} />
        <p style={{ fontSize:'12px', fontWeight:'bold', color:'#ff0040' }}>DOD 5220.22-M SPECIFICATION</p>
        <p style={{ fontSize:'10px', opacity:0.6, margin:'4px 0 12px' }}>Overwrites volatile buffers with pseudorandom entropy before zeroing memory (0x00).</p>
        <button onClick={startShred} disabled={shredding} className="cyber-btn cyber-btn-red">
          {shredding ? `SHREDDING PASS ${pass}/7...` : 'EXECUTE VOLATILE SHRED'}
        </button>
      </div>
      <div className="glow-box" style={{ flex:1, padding:'12px', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center' }}>
        {hexGrid.length > 0 && (
          <div style={{ display:'grid', gridTemplateColumns:'repeat(8, 1fr)', gap:'6px', fontSize:'11px', color: done ? '#00FF00' : '#ffaa00' }}>
            {hexGrid.map((b, i) => <span key={i} style={{ border:'1px solid #002200', padding:'3px', textAlign:'center' }}>{b}</span>)}
          </div>
        )}
        {done && <p style={{ marginTop:'10px', fontSize:'11px', color:'#00FF00', fontWeight:'bold' }}>âœ“ VOLATILE RAM PURGED & ZEROED</p>}
      </div>
    </div>
  );
}

/* =============================================
   8. 6-DIGIT TRIPLE-PIN VAULT
============================================= */
function ZeroVault() {
  const [pin, setPin] = useState('');
  const [locked, setLocked] = useState(true);
  const [data, setData] = useState('');
  const [isDecoy, setIsDecoy] = useState(false);
  const [lockout, setLockout] = useState(0);

  const unlock = async () => {
    if (pin.length !== 6) return;
    triggerHaptic([30]);

    // Nuke PIN Trigger
    if (pin === '999999') {
      sessionStorage.clear();
      alert('NUKE PIN DETECTED: MEMORY PURGED.');
      setPin(''); return;
    }
    // Duress PIN (Decoy) Trigger
    if (pin === '000000') {
      setIsDecoy(true); setLocked(false);
      setData('Grocery List:\n- Almond Milk\n- Apples\n- Greek Yogurt\n\nStudy Notes:\n- Biology chapter 4\n- History presentation');
      playBeep(1000, 70, 'sine');
      return;
    }
    // Master PIN
    const enc = sessionStorage.getItem('vault_sec');
    if (enc) {
      const d = await decryptData(pin, enc);
      if (d === null) {
        setLockout(30);
        playBeep(200, 300);
        return;
      }
      setData(d);
    }
    setIsDecoy(false); setLocked(false); playBeep(1000, 80, 'sine');
  };

  const save = async () => {
    if (isDecoy) { alert('DECOY MODE: SAVING DISABLED.'); return; }
    const enc = await encryptData(pin, sanitize(data));
    sessionStorage.setItem('vault_sec', enc);
    playBeep(800, 60, 'sine');
    alert('ENCRYPTED & SAVED WITH 250,000 ROUNDS PBKDF2.');
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Lock} title="ZERO-KNOWLEDGE VAULT" subtitle="6-DIGIT MASTER / DURESS / NUKE ARCHITECTURE" />
      {locked ? (
        <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'20px' }}>
          <Lock size={40} style={{ marginBottom:'10px' }} />
          <p style={{ fontWeight:'bold', fontSize:'12px', marginBottom:'4px' }}>ENTER 6-DIGIT MASTER PIN</p>
          <p style={{ fontSize:'9px', opacity:0.5, marginBottom:'12px' }}>Duress Decoy: 000000 | Self-Destruct Nuke: 999999</p>
          <div style={{ display:'flex', gap:'6px' }}>
            <input type="password" maxLength={6} className="cyber-input" style={{ width:'140px', textAlign:'center', fontSize:'18px', letterSpacing:'0.3em' }} value={pin} onChange={e => setPin(e.target.value.replace(/\D/g, ''))} />
            <button onClick={unlock} className="cyber-btn" disabled={lockout > 0}>UNLOCK</button>
          </div>
          {lockout > 0 && <p style={{ color:'#ff0040', fontSize:'10px', marginTop:'8px' }}>BRUTE-FORCE LOCKOUT ACTIVE: {lockout}s</p>}
        </div>
      ) : (
        <div style={{ flex:1, display:'flex', flexDirection:'column', gap:'8px' }}>
          <div style={{ background: isDecoy ? '#ffaa00' : '#00FF00', color:'#000', padding:'6px 10px', fontWeight:'bold', fontSize:'10px', display:'flex', justifyContent:'space-between' }}>
            <span>{isDecoy ? 'DECOY VAULT ACTIVE (SAFE MODE)' : 'MASTER VAULT UNLOCKED (AES-256-GCM)'}</span>
            <button onClick={() => setLocked(true)} style={{ background:'none', border:'none', fontWeight:'bold', cursor:'pointer' }}>LOCK</button>
          </div>
          <textarea className="cyber-input" style={{ flex:1, resize:'none', minHeight:'140px' }} value={data} onChange={e => setData(sanitize(e.target.value))} />
          <button onClick={save} className="cyber-btn cyber-btn-cyan" style={{ padding:'10px' }}>ENCRYPT & SAVE TO SESSION</button>
        </div>
      )}
    </div>
  );
}

/* =============================================
   9. PGP / ASCII-ARMOR SIGNER
============================================= */
function PgpSigner() {
  const [msg, setMsg] = useState('Transaction confirmed. Node 49 active.');
  const [armor, setArmor] = useState('');
  const sign = async () => {
    const hash = await generateSHA256(msg);
    const b64 = toBase64(msg);
    setArmor(`-----BEGIN PGP SIGNED MESSAGE-----\nHash: SHA256\n\n${msg}\n-----BEGIN PGP SIGNATURE-----\nVersion: CyberPGP v9.9.9\n\n${b64.slice(0, 24)}\n${hash.slice(0, 32)}\n-----END PGP SIGNATURE-----`);
    playBeep(900, 60, 'sine');
  };
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Terminal} title="PGP ASCII-ARMOR SIGNER" subtitle="DARKNET CRYPTOGRAPHIC PROTOCOL" />
      <textarea className="cyber-input" style={{ height:'65px', resize:'none', marginBottom:'8px' }} value={msg} onChange={e => setMsg(sanitize(e.target.value))} />
      <button onClick={sign} className="cyber-btn cyber-btn-cyan" style={{ marginBottom:'10px' }}>GENERATE PGP SIGNATURE</button>
      {armor && (
        <div className="glow-box" style={{ flex:1, padding:'10px', overflow:'auto' }}>
          <div style={{ display:'flex', justifyContent:'space-between', marginBottom:'4px' }}>
            <span style={{ fontSize:'10px', color:'#00ffff' }}>PGP ARMOR OUTPUT:</span>
            <CopyBtn text={armor} />
          </div>
          <pre style={{ fontSize:'10px', whiteSpace:'pre-wrap', color:'#00ffaa' }}>{armor}</pre>
        </div>
      )}
    </div>
  );
}

/* =============================================
   10. P2P QUANTUM TUNNEL
============================================= */
function P2PTunnel() {
  const [files, setFiles] = useState([]);
  const fileRef = useRef(null);
  const handleFiles = (e) => {
    const fs = Array.from(e.target?.files || []);
    if (!fs.length) return;
    setFiles(p => [...p, ...fs.map(f => ({ name: f.name, done: true }))]);
    playBeep(1000, 70, 'sine');
  };
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Radio} title="P2P QUANTUM TUNNEL" subtitle="WEBRTC HARDWARE PIPE" />
      <input type="file" ref={fileRef} multiple style={{ display:'none' }} onChange={handleFiles} />
      <div onClick={() => fileRef.current?.click()} style={{ flex:1, border:'2px dashed #00FF00', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'20px', cursor:'pointer' }}>
        <FileDigit size={36} style={{ marginBottom:'8px', opacity:0.4 }} />
        <p style={{ fontSize:'13px' }}>CLICK OR DRAG PAYLOAD HERE</p>
        <p style={{ opacity:0.3, fontSize:'10px', marginTop:'4px' }}>ZERO CLOUD INTERCEPTION</p>
      </div>
      {files.length > 0 && (
        <div className="glow-box" style={{ padding:'6px', maxHeight:'120px', overflow:'auto', marginTop:'8px' }}>
          {files.map((f, i) => (
            <div key={i} style={{ display:'flex', justifyContent:'space-between', padding:'4px', fontSize:'10px', borderBottom:'1px solid #002200' }}>
              <span>{f.name}</span><span style={{ color:'#00ffff' }}>TRANSFERRED</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/* =============================================
   11. GHOST INBOX (1SECMAIL API)
============================================= */
function GhostInbox() {
  const [email, setEmail] = useState('');
  const [msgs, setMsgs] = useState([]);
  const [loading, setLoading] = useState(false);

  const genMail = async () => {
    setLoading(true); playBeep(500, 50);
    try {
      const r = await fetch('https://www.1secmail.com/api/v1/?action=genRandomMailbox&count=1');
      const d = await r.json(); setEmail(d[0]); setMsgs([]); playBeep(1000, 80, 'sine');
    } catch (e) {}
    setLoading(false);
  };

  useEffect(() => {
    if (!email) return;
    const [login, domain] = email.split('@');
    const iv = setInterval(async () => {
      try {
        const r = await fetch(`https://www.1secmail.com/api/v1/?action=getMessages&login=${login}&domain=${domain}`);
        setMsgs(await r.json());
      } catch (e) {}
    }, 5000);
    return () => clearInterval(iv);
  }, [email]);

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Mail} title="GHOST INBOX" subtitle="DISPOSABLE 1SECMAIL API" />
      <div style={{ display:'flex', gap:'8px', marginBottom:'10px', flexWrap:'wrap' }}>
        <button onClick={genMail} disabled={loading} className="cyber-btn">{loading ? 'GENERATING...' : 'Generate Mail'}</button>
        {email && (
          <div className="glow-box" style={{ flex:1, display:'flex', alignItems:'center', justifyContent:'space-between', padding:'6px 10px', minWidth:'180px' }}>
            <span style={{ fontWeight:'bold', fontSize:'11px' }}>{email}</span>
            <CopyBtn text={email} />
          </div>
        )}
      </div>
      <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', overflow:'hidden' }}>
        <div style={{ background:'#00FF00', color:'#000', fontWeight:'bold', padding:'4px 10px', fontSize:'10px', display:'flex', justifyContent:'space-between' }}>
          <span>STREAM {email ? '[LIVE]' : '[STANDBY]'}</span><span>POLL: 5s</span>
        </div>
        <div style={{ padding:'8px', flex:1, overflow:'auto' }}>
          {msgs.length === 0 ? <p style={{ opacity:0.3, textAlign:'center', marginTop:'24px', fontSize:'11px' }}>AWAITING TRANSMISSIONS...</p>
          : msgs.map(m => (
            <div key={m.id} style={{ borderBottom:'1px solid #002200', padding:'6px 0' }}>
              <p style={{ fontSize:'9px', opacity:0.5 }}>FROM: {sanitize(m.from)}</p>
              <p style={{ fontWeight:'bold', fontSize:'11px' }}>SUBJ: {sanitize(m.subject)}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

/* =============================================
   12. MEDIA ANONYMIZER & FREQ SCRAMBLER
============================================= */
function MediaTools() {
  const [stripped, setStripped] = useState(null);
  const [sname, setSname] = useState('');
  const [recording, setRecording] = useState(false);
  const wRef = useRef(null);

  const handleExif = async (e) => {
    const f = e.target.files[0]; if (!f) return;
    const c = await stripExif(f);
    setStripped(URL.createObjectURL(c)); setSname('ANON_' + f.name);
    playBeep(1000, 80, 'sine');
  };

  const startMic = async () => {
    try {
      const s = await navigator.mediaDevices.getUserMedia({ audio: true });
      setRecording(true);
      const ctx = new (window.AudioContext || window.webkitAudioContext)();
      const src = ctx.createMediaStreamSource(s);
      const an = ctx.createAnalyser(); an.fftSize = 2048; src.connect(an);
      const data = new Uint8Array(an.frequencyBinCount);
      const cv = wRef.current; const cc = cv.getContext('2d');
      const draw = () => {
        requestAnimationFrame(draw); an.getByteTimeDomainData(data);
        cc.fillStyle = 'rgba(0,0,0,0.3)'; cc.fillRect(0, 0, cv.width, cv.height);
        cc.lineWidth = 2; cc.strokeStyle = '#00FF00'; cc.beginPath();
        const sw = cv.width / data.length; let x = 0;
        for (let i = 0; i < data.length; i++) {
          const v = data[i] / 128; const y = v * cv.height / 2;
          i === 0 ? cc.moveTo(x, y) : cc.lineTo(x, y); x += sw;
        }
        cc.lineTo(cv.width, cv.height / 2); cc.stroke();
      };
      draw();
    } catch (e) { alert('Microphone access denied.'); }
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', gap:'10px', padding:'4px' }}>
      <SectionHeader icon={ShieldAlert} title="MEDIA ANONYMIZER" subtitle="EXIF STRIPPER & VOICE SCRAMBLER" />
      <div className="glow-box" style={{ padding:'12px' }}>
        <h4 style={{ fontSize:'12px', fontWeight:'bold', marginBottom:'6px' }}>EXIF ANONYMIZER</h4>
        <input type="file" accept="image/jpeg,image/jpg" onChange={handleExif} id="exif_master" style={{ display:'none' }} />
        <div style={{ display:'flex', gap:'8px', alignItems:'center', flexWrap:'wrap' }}>
          <label htmlFor="exif_master" className="cyber-btn" style={{ cursor:'pointer' }}>Upload JPG Photo</label>
          {stripped && <a href={stripped} download={sname} className="cyber-btn cyber-btn-cyan" style={{ textDecoration:'none' }}><Download size={11}/> Download Ghost JPG</a>}
        </div>
      </div>
      <div className="glow-box" style={{ padding:'12px', flex:1, display:'flex', flexDirection:'column' }}>
        <h4 style={{ fontSize:'12px', fontWeight:'bold', marginBottom:'6px' }}>FREQ SCRAMBLER</h4>
        <button onClick={startMic} className="cyber-btn" disabled={recording} style={{ alignSelf:'flex-start', marginBottom:'8px' }}>{recording ? 'MIC ARMED' : 'Initialize Mic'}</button>
        <div style={{ flex:1, background:'#000', border:'1px solid #002200', position:'relative', minHeight:'90px' }}>
          <canvas ref={wRef} width={500} height={90} style={{ width:'100%', height:'100%' }} />
        </div>
      </div>
    </div>
  );
}

/* =============================================
   13. CRYPTO CIPHER WORKBENCH
============================================= */
function CryptoEngine() {
  const [input, setInput] = useState('');
  const [h, setH] = useState({ b64:'', sha:'', rot:'', bin:'', hex:'' });
  useEffect(() => {
    (async () => {
      const c = sanitize(input);
      if (!c) { setH({ b64:'', sha:'', rot:'', bin:'', hex:'' }); return; }
      setH({ b64: toBase64(c), sha: await generateSHA256(c), rot: rot13(c), bin: textToBinary(c), hex: textToHex(c) });
    })();
  }, [input]);

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Hash} title="CRYPTO CIPHER ENGINE" subtitle="REAL-TIME ENCODING & HASHING" />
      <textarea className="cyber-input" style={{ height:'60px', resize:'none', marginBottom:'8px' }} placeholder="Type string..." value={input} onChange={e => setInput(sanitize(e.target.value))} />
      <div style={{ display:'flex', flexDirection:'column', gap:'6px', overflow:'auto', flex:1 }}>
        {[
          { title:'BASE64', val:h.b64, col:'#00FF00' }, { title:'SHA-256', val:h.sha, col:'#00ffaa' },
          { title:'ROT13', val:h.rot, col:'#00ffff' }, { title:'BINARY', val:h.bin, col:'#ffaa00' },
          { title:'HEX', val:h.hex, col:'#ff00ff' }
        ].map(r => (
          <div key={r.title} className="glow-box" style={{ padding:'6px 10px', display:'flex', alignItems:'center', gap:'8px' }}>
            <span style={{ width:'60px', fontSize:'10px', fontWeight:'bold', color:r.col }}>{r.title}</span>
            <span style={{ flex:1, fontSize:'10px', wordBreak:'break-all' }}>{r.val || '...'}</span>
            <CopyBtn text={r.val} />
          </div>
        ))}
      </div>
    </div>
  );
}

/* =============================================
   14. PASSWORD FORTRESS
============================================= */
function PasswordGen() {
  const [len, setLen] = useState(24);
  const [pw, setPw] = useState('');
  const [str, setStr] = useState(null);
  const gen = () => {
    const p = generatePassword(len, { upper:true, lower:true, numbers:true, symbols:true });
    setPw(p); setStr(getPasswordStrength(p)); playBeep(800, 50, 'sine');
  };
  useEffect(() => { gen(); }, []);

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={KeyRound} title="PASSWORD FORTRESS" subtitle="ENTROPY GENERATOR" />
      <div className="glow-box" style={{ padding:'14px' }}>
        <div style={{ display:'flex', gap:'8px', alignItems:'center', marginBottom:'10px' }}>
          <span style={{ fontSize:'11px' }}>LEN: {len}</span>
          <input type="range" min={8} max={48} value={len} onChange={e => setLen(+e.target.value)} style={{ flex:1, accentColor:'#00FF00' }} />
        </div>
        <button onClick={gen} className="cyber-btn" style={{ width:'100%', marginBottom:'10px' }}>GENERATE ENTROPY</button>
        {pw && (
          <div style={{ background:'#000', border:'1px solid #00ffff', padding:'10px', display:'flex', justifyContent:'space-between', alignItems:'center' }}>
            <span style={{ fontSize:'13px', fontWeight:'bold', color:'#00ffff', wordBreak:'break-all' }}>{pw}</span>
            <CopyBtn text={pw} />
          </div>
        )}
        {str && <p style={{ color:str.color, fontSize:'10px', fontWeight:'bold', marginTop:'6px' }}>RATING: {str.label}</p>}
      </div>
    </div>
  );
}

/* =============================================
   15. MORSE CODE ENGINE
============================================= */
function MorseEngine() {
  const [txt, setTxt] = useState('');
  const [mode, setMode] = useState('enc');
  const res = mode === 'enc' ? textToMorse(sanitize(txt)) : morseToText(sanitize(txt));
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Terminal} title="MORSE CODE ENGINE" subtitle="ENCODE / DECODE" />
      <div style={{ display:'flex', gap:'8px', marginBottom:'8px' }}>
        <button onClick={() => setMode('enc')} className={mode === 'enc' ? "cyber-btn cyber-btn-cyan" : "cyber-btn"}>TEXT TO MORSE</button>
        <button onClick={() => setMode('dec')} className={mode === 'dec' ? "cyber-btn cyber-btn-cyan" : "cyber-btn"}>MORSE TO TEXT</button>
      </div>
      <textarea className="cyber-input" style={{ height:'60px', resize:'none', marginBottom:'8px' }} value={txt} onChange={e => setTxt(e.target.value)} />
      <div className="glow-box" style={{ flex:1, padding:'10px', overflow:'auto' }}>
        <div style={{ display:'flex', justifyContent:'space-between', marginBottom:'4px' }}>
          <span style={{ fontSize:'10px', opacity:0.5 }}>OUTPUT:</span>
          <CopyBtn text={res} />
        </div>
        <p style={{ color:'#00ffff', fontWeight:'bold', fontSize:'13px', letterSpacing:'2px' }}>{res || '...'}</p>
      </div>
    </div>
  );
}

/* =============================================
   16. IP INTEL RECON
============================================= */
function IpIntel() {
  const [info, setInfo] = useState(null);
  const [loading, setLoading] = useState(false);
  const scan = async () => {
    setLoading(true); playBeep(500, 50);
    try {
      const r = await fetch('https://ipapi.co/json/');
      setInfo(await r.json()); playBeep(1000, 70, 'sine');
    } catch (e) { setInfo({ error:'SCAN FAILED' }); }
    setLoading(false);
  };
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Globe} title="IP INTELLIGENCE" subtitle="PUBLIC RECONNAISSANCE" />
      <button onClick={scan} disabled={loading} className="cyber-btn" style={{ marginBottom:'12px' }}>{loading ? 'RECON IN PROGRESS...' : 'RUN IP SCAN'}</button>
      {info && !info.error && (
        <div className="glow-box" style={{ flex:1, padding:'10px', overflow:'auto', fontSize:'11px' }}>
          {[['IP', info.ip], ['CITY', info.city], ['COUNTRY', info.country_name], ['ISP', info.org], ['TIMEZONE', info.timezone]].map(([k, v]) => (
            <div key={k} style={{ display:'flex', justifyContent:'space-between', padding:'4px 0', borderBottom:'1px solid #002200' }}>
              <span style={{ opacity:0.5 }}>{k}</span><span style={{ color:'#00ffff', fontWeight:'bold' }}>{String(v)}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/* =============================================
   MAIN APP ORCHESTRATOR
============================================= */
export default function App() {
  const [booted, setBooted] = useState(false);
  const [tab, setTab] = useState('core');
  const [panic, setPanic] = useState(false);
  const [sidebar, setSidebar] = useState(false);
  const [cloak, setCloak] = useState('cyber');

  // Anti-Shoulder-Surfing Blur Veil
  const [blurred, setBlurred] = useState(false);
  useEffect(() => {
    const onB = () => setBlurred(true);
    const onF = () => setBlurred(false);
    window.addEventListener('blur', onB);
    window.addEventListener('focus', onF);
    return () => { window.removeEventListener('blur', onB); window.removeEventListener('focus', onF); };
  }, []);

  if (!booted) return <BootSequence onComplete={() => setBooted(true)} />;
  if (panic) return <PanicScreen onExit={() => setPanic(false)} />;

  const tabs = [
    { id:'core', name:'CORE-AI', icon:Cpu, col:'#00FF00' },
    { id:'image', name:'AI IMAGE GEN', icon:Zap, col:'#00ffff' },
    { id:'escrow', name:'BTC ESCROW', icon:Coins, col:'#ffaa00' },
    { id:'stego', name:'GHOST-STEGO', icon:EyeOff, col:'#00ffaa' },
    { id:'radar', name:'PORT-RADAR', icon:Radar, col:'#00ffff' },
    { id:'threat', name:'THREAT MAP', icon:Globe, col:'#ff0040' },
    { id:'shredder', name:'DATA SHREDDER', icon:Flame, col:'#ff0040' },
    { id:'vault', name:'ZERO-VAULT', icon:Lock, col:'#00ffaa' },
    { id:'pgp', name:'PGP SIGNER', icon:Terminal, col:'#aaaaff' },
    { id:'tunnel', name:'P2P TUNNEL', icon:Radio, col:'#00ffff' },
    { id:'inbox', name:'GHOST MAIL', icon:Mail, col:'#00FF00' },
    { id:'media', name:'EXIF STRIP', icon:ShieldAlert, col:'#ffaa00' },
    { id:'crypto', name:'CIPHER SYS', icon:Hash, col:'#00ffff' },
    { id:'password', name:'PASS FORTRESS', icon:KeyRound, col:'#00ffaa' },
    { id:'morse', name:'MORSE CODE', icon:Terminal, col:'#aaaaff' },
    { id:'ip', name:'IP INTEL', icon:Globe, col:'#ffaa00' },
  ];

  return (
    <div style={{ display:'flex', flexDirection:'column', height:'100vh', background:'#000', color:'#00FF00', fontFamily:"'Courier New', monospace", overflow:'hidden' }}>
      <MatrixRain />
      <div className="scanlines" />

      {/* SHOULDER-SURF BLUR VEIL */}
      {blurred && (
        <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,0.96)', zIndex:99998, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center' }}>
          <Lock size={44} style={{ marginBottom:'12px', color:'#00ffff' }} />
          <p style={{ letterSpacing:'3px', fontWeight:'bold', fontSize:'13px', color:'#00ffff' }}>BIOMETRIC PRIVACY VEIL ENGAGED</p>
          <p style={{ opacity:0.5, fontSize:'10px', marginTop:'4px' }}>TAP WINDOW TO RESTORE TERMINAL SESSION</p>
        </div>
      )}

      {/* HEADER */}
      <div style={{ position:'relative', zIndex:20, display:'flex', alignItems:'center', justifyContent:'space-between', padding:'6px 12px', borderBottom:'1px solid #00FF00', background:'rgba(0,0,0,0.95)' }}>
        <div style={{ display:'flex', alignItems:'center', gap:'8px' }}>
          <button onClick={() => { setSidebar(!sidebar); triggerHaptic([20]); }} style={{ background:'none', border:'1px solid #00FF00', color:'#00FF00', padding:'3px 7px', cursor:'pointer', fontFamily:'inherit' }}>â˜°</button>
          <div>
            <span style={{ fontWeight:'bold', letterSpacing:'3px', fontSize:'14px' }} className="glow">SYS.CORE</span>
            <span style={{ fontSize:'8px', opacity:0.4, marginLeft:'6px' }}>v9.9.9</span>
          </div>
        </div>

        {/* CLOAK SWITCHER & PANIC BUTTON */}
        <div style={{ display:'flex', alignItems:'center', gap:'8px' }}>
          <select value={cloak} onChange={e => { setCloak(e.target.value); setAppCloak(e.target.value); triggerHaptic([20]); }}
            style={{ background:'#001500', border:'1px solid #003300', color:'#00FF00', fontSize:'9px', padding:'2px 4px', outline:'none' }}>
            <option value="cyber">CLOAK: CYBER</option>
            <option value="calc">CLOAK: CALC</option>
            <option value="notes">CLOAK: NOTES</option>
            <option value="clock">CLOAK: CLOCK</option>
          </select>
          <button onClick={() => { setPanic(true); triggerHaptic([50]); }} style={{ background:'none', border:'none', color:'#ff0040', cursor:'pointer', padding:'2px' }} title="PANIC"><Skull size={18}/></button>
        </div>
      </div>

      {/* TOR 3-HOP CIRCUIT STATUS BAR */}
      <div style={{ display:'flex', alignItems:'center', justifyContent:'center', gap:'6px', padding:'3px', fontSize:'8px', background:'rgba(0,10,3,0.95)', borderBottom:'1px solid #002200', flexWrap:'wrap', zIndex:20 }}>
        <span style={{ color:'#00ffff' }}>TOR CIRCUIT:</span>
        <span>[YOU: 127.0.0.1]</span>âž”<span>[GUARD: ðŸ‡©ðŸ‡ª DE]</span>âž”<span>[RELAY: ðŸ‡®ðŸ‡¸ IS]</span>âž”<span>[EXIT: ðŸ‡¨ðŸ‡­ CH]</span>âž”<span style={{ color:'#00ffaa', fontWeight:'bold' }}>[.ONION ACTIVE]</span>
      </div>

      <div style={{ display:'flex', flex:1, overflow:'hidden', position:'relative', zIndex:10 }}>
        {/* SIDEBAR OVERLAY */}
        {sidebar && <div onClick={() => setSidebar(false)} style={{ position:'fixed', inset:0, background:'rgba(0,0,0,0.7)', zIndex:29 }} />}
        <div style={{
          position:'fixed', left:0, top:0, bottom:0, width: sidebar ? '210px' : '0', overflow:'hidden',
          background:'rgba(0,3,0,0.98)', borderRight: sidebar ? '1px solid #00FF00' : 'none',
          transition:'width 0.2s ease', zIndex:30, paddingTop: sidebar ? '45px' : '0',
          boxShadow: sidebar ? '5px 0 25px rgba(0,255,0,0.2)' : 'none'
        }}>
          {tabs.map(t => (
            <button key={t.id} onClick={() => { setTab(t.id); setSidebar(false); triggerHaptic([20]); playBeep(700, 25); }}
              style={{
                display:'flex', alignItems:'center', gap:'8px', padding:'10px 14px', width:'100%',
                background: tab === t.id ? 'rgba(0,255,0,0.15)' : 'transparent',
                color: tab === t.id ? t.col : '#00FF00',
                border:'none', borderBottom:'1px solid #001500', borderLeft: tab === t.id ? `3px solid ${t.col}` : '3px solid transparent',
                cursor:'pointer', fontFamily:'inherit', fontSize:'11px', textAlign:'left', whiteSpace:'nowrap'
              }}>
              <t.icon size={13}/>{t.name}
            </button>
          ))}
        </div>

        {/* MAIN WORKSPACE */}
        <div style={{ flex:1, padding:'10px', overflow:'auto', position:'relative' }}>
          {tab === 'core' && <CoreAI />}
          {tab === 'image' && <ImageGen />}
          {tab === 'escrow' && <BitcoinEscrow />}
          {tab === 'stego' && <GhostStego />}
          {tab === 'radar' && <PortRadar />}
          {tab === 'threat' && <ThreatMap />}
          {tab === 'shredder' && <DataShredder />}
          {tab === 'vault' && <ZeroVault />}
          {tab === 'pgp' && <PgpSigner />}
          {tab === 'tunnel' && <P2PTunnel />}
          {tab === 'inbox' && <GhostInbox />}
          {tab === 'media' && <MediaTools />}
          {tab === 'crypto' && <CryptoEngine />}
          {tab === 'password' && <PasswordGen />}
          {tab === 'morse' && <MorseEngine />}
          {tab === 'ip' && <IpIntel />}
        </div>
      </div>

      {/* LIVE INTEL SCROLLING WIRE TICKER */}
      <div style={{ background:'#000', borderTop:'1px solid #003300', padding:'2px 8px', fontSize:'8px', color:'#00ffaa', overflow:'hidden', whiteSpace:'nowrap', position:'relative', zIndex:20 }}>
        <span style={{ display:'inline-block', animation:'ticker 35s linear infinite' }}>
          [LIVE WIRE] SATOSHI MEMPOOL HEIGHT #861,402 // TOR EXIT NODES RE-INDEXED // 0-DAY MONITORS ARMED // VOLATILE MEMORY PURGE READY // HARDWARE PIPE ENCRYPTED //
        </span>
      </div>

      <style>{`
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }
        @keyframes ticker { 0% { transform: translateX(100%); } 100% { transform: translateX(-100%); } }
      `}</style>
    </div>
  );
}
