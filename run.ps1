<#
.SYNOPSIS
    MejorarWindows - The Ultimate Windows Toolbox
    Basado en el repositorio oficial de Chris Titus Tech WinUtil con el perfil Standard optimizado.
.DESCRIPTION
    Lanza MejorarWindows como Administrador.
    - Desde una copia local (.\run.ps1): usa el winutil.ps1 que esta junto a este archivo.
    - Desde la web (irm .../run.ps1 | iex): descarga winutil.ps1 de la rama main del fork.
    El texto de este archivo es solo ASCII a proposito: Windows PowerShell 5.1 lee los
    archivos sin BOM como ANSI y mostraria mal las tildes.
#>

$winutilUrl = 'https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/winutil.ps1'
$runUrl = 'https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/run.ps1'

# Only a script run from disk has a folder of its own. Piped through iex there is none, and the
# current folder (often System32 or Downloads) must not decide what code runs as Administrador.
$localWinutil = if ($PSCommandPath) { Join-Path (Split-Path -Parent $PSCommandPath) 'winutil.ps1' }
$isLocal = $localWinutil -and (Test-Path -LiteralPath $localWinutil)

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[MejorarWindows] Elevando privilegios a Administrador..." -ForegroundColor Yellow
    $shell = (Get-Process -Id $PID).Path
    if ($isLocal) {
        Start-Process $shell -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"") -Verb RunAs
    } else {
        Start-Process $shell -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', "irm '$runUrl' | iex") -Verb RunAs
    }
    return
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "           MejorarWindows - The Windows Toolbox           " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if ($isLocal) {
    Write-Host "[MejorarWindows] Iniciando winutil.ps1 local..." -ForegroundColor Green
    # A child process, so the execution policy of the console that started this file does not apply
    & (Get-Process -Id $PID).Path -NoProfile -ExecutionPolicy Bypass -File $localWinutil
    return
}

Write-Host "[MejorarWindows] Descargando y ejecutando la ultima version..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
& ([ScriptBlock]::Create((Invoke-RestMethod -Uri $winutilUrl -UseBasicParsing)))
