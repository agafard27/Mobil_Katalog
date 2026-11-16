# Yerel araçlar varsa yalnızca bu PowerShell süreci için etkinleştirir.
$projectRoot = Split-Path -Parent $PSScriptRoot
$sdkConfig = Join-Path $projectRoot '.tools/android-sdk-path.txt'
if ((Test-Path -LiteralPath $sdkConfig) -and -not $env:ANDROID_HOME) {
    $env:ANDROID_HOME = (Get-Content -LiteralPath $sdkConfig -Raw).Trim()
}
$javaRoot = Join-Path $projectRoot '.tools/java'
if (Test-Path -LiteralPath $javaRoot) {
    $localJava = Get-ChildItem -LiteralPath $javaRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName 'bin/java.exe')
    } | Select-Object -First 1
    if ($localJava) { $env:JAVA_HOME = $localJava.FullName }
}
if ($env:JAVA_HOME) { $env:PATH = "$env:JAVA_HOME/bin;$env:PATH" }
if ($env:ANDROID_HOME) {
    $env:GRADLE_USER_HOME = Join-Path $projectRoot '.tools/gradle-cache'
    $env:ANDROID_USER_HOME = Join-Path $projectRoot '.tools/android-home'
    $env:ANDROID_AVD_HOME = Join-Path $env:ANDROID_USER_HOME 'avd'
    $env:ANDROID_EMULATOR_HOME = $env:ANDROID_USER_HOME
    $localAdbKey = Join-Path $env:ANDROID_USER_HOME 'adbkey'
    if (Test-Path -LiteralPath $localAdbKey) { $env:ADB_VENDOR_KEYS = $localAdbKey }
}
