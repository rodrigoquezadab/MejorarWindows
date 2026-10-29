<#
.SYNOPSIS
    MejorarWindows - The Ultimate Windows Toolbox
    Basado en el repositorio oficial de Chris Titus Tech WinUtil con el perfil Standard optimizado.
.DESCRIPTION
    Script de arranque rápido para lanzar MejorarWindows como Administrador.
#>

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[MejorarWindows] Elevando privilegios a Administrador..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"`$host.UI.RawUI.WindowTitle = 'MejorarWindows'; irm https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/run.ps1 | iex`"" -Verb RunAs
    exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "           MejorarWindows - The Windows Toolbox           " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$localWinutil = Join-Path $scriptDir "winutil.ps1"

if (Test-Path $localWinutil) {
    Write-Host "[MejorarWindows] Iniciando winutil.ps1 local..." -ForegroundColor Green
    & powershell -NoProfile -ExecutionPolicy Bypass -File $localWinutil
    exit
}

# Ejecución remota vía web
Write-Host "[MejorarWindows] Descargando y ejecutando la última versión..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/winutil.ps1')
