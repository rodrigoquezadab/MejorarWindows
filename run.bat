@echo off
setlocal
cd /d "%~dp0"

echo ========================================================
echo        Iniciando MejorarWindows (WinUtil)
echo ========================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando permisos de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

if not exist "winutil.ps1" (
    echo Compilando winutil.ps1...
    powershell -NoProfile -ExecutionPolicy Bypass -File "Compile.ps1"
)

echo Ejecutando MejorarWindows (WinUtil)...
powershell -NoProfile -ExecutionPolicy Bypass -File "winutil.ps1"
