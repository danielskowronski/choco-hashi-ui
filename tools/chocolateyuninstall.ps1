$packageName = $env:ChocolateyPackageName

nssm.exe stop   $packageName
nssm.exe remove $packageName confirm
