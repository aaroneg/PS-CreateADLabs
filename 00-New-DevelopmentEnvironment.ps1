# Change directory to the running user's documents folder
Set-Location $env:userprofile\Documents\
# Install several modules to enable git in powershell
Install-Module posh-git -Force
install-module chocolatey
install-chocolateysoftware
install-chocolateypackage git
Import-Module posh-git
# Make sure posh-git is loaded every time powershell is opened
'import-module posh-git'|out-file $PROFILE -Append
