Set-Location $env:userprofile\Documents\
Install-Module posh-git -Force
install-module chocolatey
install-chocolateysoftware
install-chocolateypackage git
Import-Module posh-git
'import-module posh-git'|out-file $PROFILE -Append
