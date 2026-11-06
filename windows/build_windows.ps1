# SweePurge Windows Edition Builder (PowerShell)
# Compiles portable PE32+ x86_64 GUI standalone executable for Windows 10/11
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = (Get-Item "$scriptDir\..").FullName
$windowsDir = "$projectDir\windows"
$outputExe = "$projectDir\SweePurge.exe"
$zipOutput = "$projectDir\SweePurge-Windows.zip"

Write-Host "Compiling Standalone Windows GUI Executable..." -ForegroundColor Cyan

$env:GOCACHE = "$projectDir\..\gocache"
Push-Location "$windowsDir\src"
try {
    $goExe = (Get-Command go -ErrorAction SilentlyContinue).Source
    if (-not $goExe -and (Test-Path "C:\Program Files\Go\bin\go.exe")) {
        $goExe = "C:\Program Files\Go\bin\go.exe"
    }
    if (-not $goExe) {
        throw "Go compiler (go.exe) not found on PATH or in 'C:\Program Files\Go\bin\go.exe'."
    }
    & $goExe build -ldflags="-H windowsgui -s -w" -o "$outputExe"
} finally {
    Pop-Location
}

Write-Host "Packaging SweePurge-Windows.zip..." -ForegroundColor Cyan
if (Test-Path -LiteralPath $zipOutput) {
    Remove-Item -LiteralPath $zipOutput -Force
}
Compress-Archive -Path "$outputExe" -DestinationPath "$zipOutput" -Force

Write-Host "Windows Build Complete!" -ForegroundColor Green
Get-Item "$outputExe", "$zipOutput" | Select-Object Name, Length, LastWriteTime
