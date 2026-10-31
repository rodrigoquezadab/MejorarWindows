# Runs the latest MejorarWindows build from the main branch

$uri = "https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/winutil.ps1"
$scriptPath = Join-Path $env:TEMP "winutil-mejorarwindows.ps1"

Invoke-WebRequest -Uri $uri -OutFile $scriptPath -UseBasicParsing -ErrorAction Stop

$executable = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh.exe' } else { 'powershell.exe' }
$currentPowerShell = Join-Path $PSHOME $executable
& $currentPowerShell -ExecutionPolicy Bypass -NoProfile -File $scriptPath
