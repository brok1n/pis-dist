# pis installer — one-line install for Windows
#
# Usage:
#   irm https://raw.githubusercontent.com/brok1n/pis-dist/main/install.ps1 | iex
#   (or from gitee mirror)
#
# Downloads the latest release from the public distribution repo,
# extracts and installs into %APPDATA%\npm (same dir as pi, already on PATH).
# Files written by this script carry no Mark-of-the-Web, so auto-update works.

$ErrorActionPreference = "Stop"

# ---- config ---------------------------------------------------------------
$GiteeRepo = "brok1n/pis-dist"      # primary source (direct connection in CN)
$GithubRepo = "brok1n/pis-dist"     # fallback
$InstallDir = "$env:APPDATA\npm"

# ---- platform detect ------------------------------------------------------
$arch = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture
if ($arch -ne "X64") {
    Write-Error "Unsupported architecture: $arch (only x64 is packaged)"
    exit 1
}
$asset = "pis-latest-x86_64-pc-windows-msvc.zip"

# ---- download (gitee first, github fallback) ------------------------------
$tmpZip = Join-Path $env:TEMP "$asset"
$urls = @(
    "https://gitee.com/$GiteeRepo/releases/download/latest/$asset",
    "https://github.com/$GithubRepo/releases/download/latest/$asset"
)

$downloaded = $false
foreach ($u in $urls) {
    Write-Host "[pis] downloading from $u ..." -ForegroundColor DarkGray
    try {
        Invoke-WebRequest -Uri $u -OutFile $tmpZip -TimeoutSec 60 -ErrorAction Stop
        $downloaded = $true
        break
    } catch {
        Write-Host "[pis]   failed: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}
if (-not $downloaded) {
    Write-Error "[pis] all sources failed. Check your network."
    exit 1
}

# ---- extract & install ----------------------------------------------------
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Force $InstallDir | Out-Null }
$dest = Join-Path $InstallDir "pis.exe"
Expand-Archive -Path $tmpZip -DestinationPath $env:TEMP -Force
Copy-Item (Join-Path $env:TEMP "pis.exe") $dest -Force
Remove-Item $tmpZip, (Join-Path $env:TEMP "pis.exe") -Force -ErrorAction SilentlyContinue

Write-Host "[pis] installed: $dest" -ForegroundColor Green
Write-Host "[pis] open a NEW terminal and type 'pis' in any pi project directory."
