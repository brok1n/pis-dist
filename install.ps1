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

# ---- resolve latest release (gitee API first, github fallback) ------------
$tag = $null
$assetUrl = $null
try {
    $r = Invoke-RestMethod -Uri "https://gitee.com/api/v5/repos/$GiteeRepo/releases/latest" -TimeoutSec 15
    $tag = $r.tag_name
    $assetUrl = ($r.assets | Where-Object { $_.name -eq "pis-$tag-x86_64-pc-windows-msvc.zip" } | Select-Object -First 1).browser_download_url
    Write-Host "[pis] gitee: latest=$tag" -ForegroundColor DarkGray
} catch {
    Write-Host "[pis]   gitee api failed: $($_.Exception.Message)" -ForegroundColor DarkYellow
}
if (-not $assetUrl) {
    try {
        $r = Invoke-RestMethod -Uri "https://api.github.com/repos/$GithubRepo/releases/latest" -TimeoutSec 15
        $tag = $r.tag_name
        $assetUrl = ($r.assets | Where-Object { $_.name -eq "pis-$tag-x86_64-pc-windows-msvc.zip" } | Select-Object -First 1).browser_download_url
        Write-Host "[pis] github: latest=$tag" -ForegroundColor DarkGray
    } catch {
        Write-Host "[pis]   github api failed: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}
if (-not $assetUrl) {
    Write-Error "[pis] cannot resolve latest release from any source."
    exit 1
}

$asset = "pis-$tag-x86_64-pc-windows-msvc.zip"

# ---- download -------------------------------------------------------------
$tmpZip = Join-Path $env:TEMP "$asset"
Write-Host "[pis] downloading $asset ..." -ForegroundColor DarkGray
try {
    Invoke-WebRequest -Uri $assetUrl -OutFile $tmpZip -TimeoutSec 120 -ErrorAction Stop
} catch {
    Write-Error "[pis] download failed: $($_.Exception.Message)"
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
