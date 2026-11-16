$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot
& powershell -ExecutionPolicy Bypass -File "$PSScriptRoot/flutter.ps1" build web --release --no-web-resources-cdn
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
node scripts/serve.mjs
