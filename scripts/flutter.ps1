# Yerel SDK mevcutsa onu kullanır; makinenin PATH ayarını değiştirmez.
$projectRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'android-env.ps1')
$localSdk = Join-Path $projectRoot '.tools/flutter/bin/flutter.bat'
if (Test-Path -LiteralPath $localSdk) {
    $env:GIT_CONFIG_COUNT = '1'
    $env:GIT_CONFIG_KEY_0 = 'safe.directory'
    $env:GIT_CONFIG_VALUE_0 = Split-Path -Parent (Split-Path -Parent $localSdk)
    $env:PUB_CACHE = Join-Path $projectRoot '.pub-cache'
    $env:APPDATA = Join-Path $projectRoot '.tools/profile/roaming'
    $env:LOCALAPPDATA = Join-Path $projectRoot '.tools/profile/local'
    $env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
    $env:CI = 'true'
    New-Item -ItemType Directory -Force -Path $env:APPDATA, $env:LOCALAPPDATA | Out-Null
    & $localSdk --suppress-analytics @args
} else {
    & flutter @args
}
exit $LASTEXITCODE
