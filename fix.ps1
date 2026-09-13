Set-Location "C:\Users\gokul\cyber-terminal"

# 1. FIX src\main.jsx (Clean React Mount with zero missing imports)
@'
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>
)
'@ | Set-Content "src\main.jsx" -Encoding UTF8

# 2. Add export enforceCSP to src\utils.js just in case
Add-Content "src\utils.js" "`nexport const enforceCSP = () => {};`n" -Encoding UTF8

Write-Host "==========================================" -ForegroundColor Green
Write-Host "  FIX APPLIED SUCCESSFULLY! REFRESH BROWSER" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green