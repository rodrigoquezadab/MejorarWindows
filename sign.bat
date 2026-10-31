@echo off
rem Signs winutil.ps1 with your own code signing certificate.
rem Usage: sign.bat "Certificate subject name"
rem Note: the build workflow republishes an unsigned winutil.ps1 on every push to main.
if "%~1"=="" (
    echo Usage: sign.bat "Certificate subject name"
    exit /b 1
)
signtool.exe sign /td sha256 /tr http://timestamp.digicert.com /fd sha256 /n "%~1" .\winutil.ps1
