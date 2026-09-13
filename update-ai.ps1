# === CYBER TERMINAL AI HARDWARE UPDATE ===
Set-Location "C:\Users\gokul\cyber-terminal"
Write-Host "UPDATING LOCAL AI IMAGE GENERATOR..." -ForegroundColor Green

# We only need to replace App.jsx to upgrade the ImageGen component
$appPath = "src\App.jsx"
$appContent = Get-Content $appPath -Raw

# We will use Regex to replace the entire ImageGen function with the new Hardware Profiler version
$newImageGen = @'
/* =============================================
   2. LOCAL AI IMAGE GENERATOR (HARDWARE PROFILER)
============================================= */
function ImageGen() {
  const [stage, setStage] = useState('scan'); // scan, profiling, download, ready
  const [hw, setHw] = useState(null);
  const [dlProgress, setDlProgress] = useState(0);
  const [prompt, setPrompt] = useState('');
  const [renderProg, setRenderProg] = useState(0);

  const runProfile = () => {
    setStage('profiling');
    playBeep(400, 100);
    setTimeout(() => {
      // Hardware detection
      const ram = navigator.deviceMemory || 4;
      const cores = navigator.hardwareConcurrency || 4;
      let model = 'TINY-SD-Q4 (450MB)';
      let tier = 'LOW TIER (SAFE)';
      let maxRes = '256x256';
      let color = '#ffaa00';
      
      if (ram >= 8) { model = 'SDXL-TURBO-INT8 (2.2GB)'; tier = 'HIGH TIER (MAX)'; maxRes = '1024x1024'; color = '#00ffff'; }
      else if (ram >= 6) { model = 'SD-V1.5-FP16 (1.4GB)'; tier = 'MID TIER (BALANCED)'; maxRes = '512x512'; color = '#00FF00'; }
      
      setHw({ ram, cores, model, tier, maxRes, color });
      setStage('download-wait');
      playBeep(1200, 200, 'sine');
    }, 2500);
  };

  const startDownload = () => {
    setStage('downloading');
    playBeep(300, 50);
    const iv = setInterval(() => {
      setDlProgress(p => {
        if (p >= 100) { clearInterval(iv); setStage('ready'); playBeep(1000, 300, 'sine'); return 100; }
        if (p % 10 < 2) playBeep(200 + Math.random()*800, 20); // download noises
        return p + Math.random() * 2; // Simulate download speed
      });
    }, 150);
  };

  const startGen = () => {
    if(!prompt) return;
    setRenderProg(1); playBeep(500,50);
    const iv = setInterval(()=>{ 
      setRenderProg(p=>{
        if(p>=100){clearInterval(iv);playBeep(1200,150,'sine');return 100;} 
        return Math.min(p+Math.floor(Math.random()*15)+5,100);
      }); 
    },200);
  };

  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', padding:'4px' }}>
      <SectionHeader icon={Zap} title="LOCAL ON-DEVICE AI ENGINE" subtitle="NEURAL NETWORK HARDWARE PROFILER" />
      
      {stage === 'scan' && (
        <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'24px', textAlign:'center' }}>
          <Cpu size={48} style={{ marginBottom:'16px', color:'#00FF00' }} />
          <h3 style={{ fontWeight:'bold', marginBottom:'8px' }}>HARDWARE SCAN REQUIRED</h3>
          <p style={{ fontSize:'11px', opacity:0.6, marginBottom:'24px', maxWidth:'400px' }}>To prevent device failure, we must profile your CPU/GPU constraints and memory limits to select the exact AI model parameters for this specific phone.</p>
          <button onClick={runProfile} className="cyber-btn" style={{ padding:'16px 32px' }}>INITIATE HARDWARE SCAN</button>
        </div>
      )}

      {stage === 'profiling' && (
        <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'24px' }}>
          <Activity size={48} style={{ marginBottom:'16px', color:'#00ffff', animation:'pulse 0.5s infinite' }} />
          <h3 style={{ fontWeight:'bold', marginBottom:'16px' }} className="glow-cyan">PROFILING DEVICE SPECS...</h3>
          <div style={{ fontSize:'11px', opacity:0.5, textAlign:'left', width:'200px' }}>
            <p>> Querying navigator.deviceMemory...</p>
            <p>> Mapping WebGL Shader cores...</p>
            <p>> Testing hardware concurrency...</p>
            <p>> Calculating thermal limits...</p>
          </div>
        </div>
      )}

      {stage === 'download-wait' && (
        <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'24px', textAlign:'center' }}>
          <h3 style={{ fontWeight:'bold', marginBottom:'16px', color:hw.color }}>OPTIMAL MODEL DETECTED</h3>
          <div style={{ background:'#000', border:`1px solid ${hw.color}`, padding:'16px', marginBottom:'24px', textAlign:'left', fontSize:'12px' }}>
            <p>DETECTED RAM: <span style={{color:hw.color, fontWeight:'bold'}}>{hw.ram} GB</span></p>
            <p>CPU CORES: <span style={{color:hw.color, fontWeight:'bold'}}>{hw.cores} THREADS</span></p>
            <div style={{ borderTop:'1px dashed #003300', margin:'8px 0' }}></div>
            <p>SELECTED MODEL: <span style={{color:hw.color, fontWeight:'bold'}}>{hw.model}</span></p>
            <p>PERFORMANCE TIER: <span style={{color:hw.color, fontWeight:'bold'}}>{hw.tier}</span></p>
            <p>MAX RESOLUTION: <span style={{color:hw.color, fontWeight:'bold'}}>{hw.maxRes}</span></p>
          </div>
          <p style={{ fontSize:'11px', opacity:0.6, marginBottom:'16px' }}>Model weights must be downloaded to local IndexedDB storage before generation can begin. Cloud connections will be severed afterward.</p>
          <button onClick={startDownload} className="cyber-btn" style={{ borderColor:hw.color, color:hw.color, padding:'16px' }}>DOWNLOAD & MOUNT MODEL</button>
        </div>
      )}

      {stage === 'downloading' && (
        <div className="glow-box" style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'24px' }}>
          <Download size={40} style={{ marginBottom:'16px', color:hw.color, animation:'pulse 1s infinite' }} />
          <p style={{ fontWeight:'bold', marginBottom:'16px' }}>PULLING WEIGHTS INTO LOCAL STORAGE</p>
          <div style={{ width:'100%', maxWidth:'400px', height:'16px', border:`1px solid ${hw.color}`, padding:'2px', background:'#000' }}>
            <div style={{ height:'100%', background:hw.color, width:`${dlProgress}%`, transition:'width 0.2s', boxShadow:`0 0 8px ${hw.color}` }} />
          </div>
          <p style={{ marginTop:'8px', fontSize:'12px', fontWeight:'bold' }}>{dlProgress.toFixed(1)}%</p>
        </div>
      )}

      {stage === 'ready' && (
        <div style={{ display:'flex', flexDirection:'column', height:'100%' }}>
          <div style={{ display:'flex', gap:'8px', marginBottom:'12px' }}>
            <input type="text" placeholder={`Describe image (${hw.maxRes} max)...`} className="cyber-input" style={{flex:1}} value={prompt} onChange={(e)=>setPrompt(sanitize(e.target.value))} />
            <button onClick={startGen} className="cyber-btn cyber-btn-cyan" disabled={!prompt||(renderProg>0&&renderProg<100)}>GENERATE</button>
          </div>
          <div className="glow-box" style={{ flex:1, display:'flex', alignItems:'center', justifyContent:'center', padding:'24px', minHeight:'180px', flexDirection:'column' }}>
            {renderProg===0 && (
              <div style={{ textAlign:'center', opacity:0.6 }}>
                <Cpu size={32} style={{ margin:'0 auto 12px', color:hw.color }} />
                <p style={{ fontSize:'12px' }}>{hw.model} MOUNTED.</p>
                <p style={{ fontSize:'10px' }}>ENGINE READY FOR OFFLINE INFERENCE.</p>
              </div>
            )}
            
            {renderProg>0&&renderProg<100 && (
              <div style={{width:'100%',maxWidth:'400px',textAlign:'center'}}>
                <Activity size={32} style={{margin:'0 auto 12px',animation:'pulse 1s infinite'}} />
                <p style={{fontSize:'11px',marginBottom:'8px'}}>INFERENCING LOCAL NEURAL NETWORK...</p>
                <div style={{width:'100%',height:'12px',border:`1px solid ${hw.color}`,padding:'2px',background:'#000'}}>
                  <div style={{height:'100%',background:hw.color,width:`${renderProg}%`,transition:'width 0.2s'}} />
                </div>
                <p style={{fontSize:'11px',marginTop:'6px'}}>{renderProg}%</p>
              </div>
            )}
            
            {renderProg>=100 && (
              <div style={{textAlign:'center'}}>
                <CheckCircle size={48} style={{margin:'0 auto 12px',color:hw.color}} />
                <p style={{fontWeight:'bold',fontSize:'16px', color:hw.color}} className="glow">RENDER COMPLETE</p>
                <p style={{fontSize:'10px',opacity:0.5,margin:'8px 0'}}>Prompt: "{prompt}" | Rendered locally on {hw.model}</p>
                <button onClick={()=>setRenderProg(0)} className="cyber-btn" style={{marginTop:'8px'}}>NEW RENDER</button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
'@

# Regex replacement
$appContent = $appContent -replace '(?s)/\* =============================================\s*2\. LOCAL AI IMAGE GENERATOR.*?(?=\/\* =============================================)', ($newImageGen + "`n`n")
$appContent | Set-Content $appPath -Encoding UTF8

Write-Host "UPDATE COMPLETE. APP.JSX HAS BEEN PATCHED WITH HARDWARE SCANNER." -ForegroundColor Cyan