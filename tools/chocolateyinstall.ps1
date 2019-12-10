# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f


$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url         = 'https://github.com/jippi/hashi-ui/releases/download/v1.3.0/hashi-ui-windows-amd64'
$checksum    = 'ad832a04af3ffc217181db6c37336a3f583c6cfe1b155430888d696c35df75f5'
$filePath    = "C:\ProgramData\chocolatey\tools\hashi-ui.exe"
$packageName = $env:ChocolateyPackageName
$pp          = Get-PackageParameters

if (!$pp['listen-address']) {
  $listenAddress   = 'http://0.0.0.0:8503'
} else {
  $listenAddress   = $pp['listen-address']
}

if ($pp['consul-enabled'])  {
  $servicesToEnable="$servicesToEnable --consul-enable"
}
if ($pp['nomad-enabled'] )  {
  $servicesToEnable="$servicesToEnable --nomad-enable"
}
if (!$pp['consul-enabled'] -and !$pp['nomad-enabled']) {
  $servicesToEnable="--consul-enable --nomad-enable"
}

if (!$pp['consul-address']) {
  $consulAddress   = 'http://127.0.0.1:8500'
} else {
  $consulAddress   = $pp['consul-address']
}

if (!$pp['nomad-address'])  {
  $nomadAddress    = 'http://127.0.0.1:4646'
} else {
  $nomadAddress    = $pp['nomad-address']
}

if ($pp['other-params'])   {
  $otherParams     = $pp['other-params']
}

$exeParams = "$servicesToEnable -consul-address $consulAddress -nomad-address $nomadAddress -listen-address $listenAddress $otherParams"

Get-ChocolateyWebFile  -PackageName $packageName -FileFullPath $filePath -Url64bit $url -Checksum $checksum
nssm.exe install $packageName $filePath $exeParams
nssm.exe start   $packageName