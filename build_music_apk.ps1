# Builds the Android release APK. Gradle saves it as
# build\app\outputs\flutter-apk\music.apk (see android/app/build.gradle.kts).
# Usage: powershell -ExecutionPolicy Bypass -File .\build_music_apk.ps1
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

flutter build apk --release
if ($LASTEXITCODE -ne 0) { throw "flutter build apk failed with exit code $LASTEXITCODE" }

$target = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\music.apk'
$size = [math]::Round((Get-Item $target).Length / 1MB, 1)
Write-Host "Built $target ($size MB)"
