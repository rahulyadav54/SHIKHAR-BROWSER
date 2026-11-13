@echo off
setlocal
echo ========================================================
echo    SHIKHAR BROWSER - WINDOWS SETUP INSTALLER BUILDER
echo ========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-installer.ps1"
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Installer build failed with error code %errorlevel%.
    exit /b %errorlevel%
)
echo.
echo [DONE] Installer built successfully.
pause
