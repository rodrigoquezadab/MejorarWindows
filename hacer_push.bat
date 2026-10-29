@echo off
cd /d "%~dp0"
echo ==========================================================
echo           Subiendo MejorarWindows a GitHub
echo ==========================================================
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

