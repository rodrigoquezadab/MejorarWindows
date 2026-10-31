@echo off
cd /d "%~dp0"
echo ==========================================================
echo           Subiendo MejorarWindows a GitHub
echo ==========================================================
echo.
rem GitHub Actions commits the compiled winutil.ps1 to main, so main may be ahead of this copy.
rem A locally compiled winutil.ps1 is only a test build: drop it so it cannot clash with the published one.
git checkout -- winutil.ps1 2>nul
echo Ejecutando: git pull --rebase --autostash origin main
git pull --rebase --autostash origin main
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [AVISO] No se pudo actualizar desde GitHub. Revisa los conflictos con "git status".
    pause
    exit /b 1
)
echo.
echo Ejecutando: git push -u origin main
echo.
git push -u origin main
echo.
echo ==========================================================
if %ERRORLEVEL% EQU 0 (
    echo [EXITO] Proyecto subido correctamente a GitHub.
) else (
    echo [AVISO] Si pide credenciales, autoriza en la ventana del navegador.
)
echo ==========================================================
echo.
pause

