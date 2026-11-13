# SHIKHAR Browser - Windows Setup Installer Builder
# Automates Inno Setup compilation for Windows releases

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    SHIKHAR BROWSER - WINDOWS SETUP INSTALLER BUILDER      " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$rootDir = Split-Path -Parent $PSScriptRoot
$releaseDir = Join-Path $rootDir "build\windows\x64\runner\Release"
$exePath = Join-Path $releaseDir "shikhar_browser.exe"
$issPath = Join-Path $rootDir "installer\shikhar_browser_setup.iss"
$outputDir = Join-Path $rootDir "installer_output"
$installerExe = Join-Path $outputDir "SHIKHAR-Browser-Windows-Setup.exe"

# 1. Verify / Build Windows release
if (-not (Test-Path $exePath)) {
    Write-Host "`n[1/3] Release binary not found. Building Flutter Windows release..." -ForegroundColor Yellow
    Push-Location $rootDir
    flutter build windows --release
    Pop-Location
} else {
    Write-Host "`n[1/3] Found existing Windows release at: $releaseDir" -ForegroundColor Green
}

# 2. Locate Inno Setup Compiler (ISCC.exe)
$isccCandidates = @(
    "C:\Users\zayad\AppData\Local\Programs\Inno Setup 6\ISCC.exe",
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe"
)

$isccPath = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $isccPath) {
    Write-Host "`nInno Setup 6 not found. Attempting install via winget..." -ForegroundColor Yellow
    winget install --id JRSoftware.InnoSetup -e --silent --accept-source-agreements --accept-package-agreements
    $isccPath = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $isccPath) {
    Write-Error "ISCC.exe could not be found or installed. Please install Inno Setup 6 from https://jrsoftware.org/isdl.php"
}

Write-Host "`n[2/3] Compiling Setup Installer with Inno Setup ($isccPath)..." -ForegroundColor Cyan
& $isccPath $issPath

if (-not (Test-Path $installerExe)) {
    Write-Error "Installer compilation failed. Output file not found."
}

# 3. Distribute output installer
Write-Host "`n[3/3] Distributing installer executable..." -ForegroundColor Cyan
$rootInstaller = Join-Path $rootDir "SHIKHAR-Browser-Windows-Setup.exe"
$websiteInstaller = Join-Path $rootDir "website\public\SHIKHAR-Browser-Windows-Setup.exe"

Copy-Item $installerExe $rootInstaller -Force
Copy-Item $installerExe $websiteInstaller -Force

$sizeMB = [math]::Round(((Get-Item $installerExe).Length / 1MB), 2)
Write-Host "`nSUCCESS! Windows Setup Installer created:" -ForegroundColor Green
Write-Host "  -> Location: $rootInstaller" -ForegroundColor White
Write-Host "  -> Website:  $websiteInstaller" -ForegroundColor White
Write-Host "  -> Size:     $sizeMB MB" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

