$projectRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'android-env.ps1')
if (-not $env:ANDROID_HOME) { throw 'ANDROID_HOME tanımlı değil. Önce Android SDK kurulmalı.' }
$emulator = Join-Path $env:ANDROID_HOME 'emulator/emulator.exe'
$avdConfig = Join-Path $env:ANDROID_AVD_HOME 'Mini_Katalog.ini'
if (-not (Test-Path -LiteralPath $avdConfig)) {
    throw 'Mini_Katalog sanal cihazı bulunamadı. Android Studio Device Manager ile bir cihaz oluşturun.'
}
& $emulator -avd Mini_Katalog -no-snapshot -no-audio -gpu swiftshader_indirect -no-metrics
