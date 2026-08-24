param(
    [Parameter(Mandatory = $true)]
    [string]$Version,
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^https://')]
    [string]$ApkUrl,
    [string]$Notes = ''
)

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$apkSource = Join-Path $projectRoot 'android\app\build\outputs\apk\debug\app-debug.apk'
$updatesDirectory = Join-Path $projectRoot 'updates'
$apkName = "today-todo-$Version.apk"

if (-not (Test-Path $apkSource)) {
    throw "APK not found. Run npm run build:android first."
}

New-Item -ItemType Directory -Force -Path $updatesDirectory | Out-Null
Copy-Item $apkSource (Join-Path $updatesDirectory $apkName) -Force

$manifest = [ordered]@{
    version = $Version
    apkUrl = $ApkUrl
    notes = $Notes
}
$manifest | ConvertTo-Json | Set-Content (Join-Path $updatesDirectory 'latest.json') -Encoding utf8
Write-Host "Published $apkName and latest.json to $updatesDirectory"