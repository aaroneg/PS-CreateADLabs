# This script should be run on the machine that you intend to be your first AD controller in the domain. 
# It is designed to be run from a USB stick.
<#
 Change this. This is just an example.
 https://docs.microsoft.com/en-us/office365/enterprise/overview-of-the-contoso-corporation
 #>
$BaseDomainFQDN="contoso.com"
$EthernetAdapterName='Ethernet0'

# In case this script was started from somewhere other than the directory it lives in
Set-Location $PSScriptRoot

# This script assumes that you have several different groups or teams of people using your labs, 
# all of whom will be on their own address space.
$TeamNumber=Read-Host -Prompt 'Which team is this? [0-255]'

<#
 Create a custom object that describes the config that we can use later to apply other settings.
 This assumes that the Ethernet adapter's name is 'Ethernet0'. There are other ways to determine which 
 Ethernet adapter is the real wired adapter, this was the simplest at the time.
 The script does NOT assume a Class "C" (/24) address scheme, but does have prefilled values that should
 be changed.
#>
$TeamConfig=@{
    TeamNumber   = $TeamNumber
    Interface    = ((Get-NetIPInterface|Where{$_.InterfaceAlias -eq $EthernetAdapterName})[0].ifIndex)
    DomainName   = "ad.team$($TeamNumber).$($BaseDomainFQDN)"
    NetMask      = "255.255.255.224"
    PrefixLength = 27
    Gateway      = "172.16.$($TeamNumber).65"
    UpstreamDNS  = "172.16.$($TeamNumber).91"
    ADC0Name     = "ADC$($TeamNumber)"
    ADC0IP       = "172.16.$($TeamNumber).66"
}

<#
 Now that powershell has this custom object in memory, save it to disk as XML so subsequent scripts can 
 use it to fill in answers without asking these questions all over again.
#>
$TeamConfig|Export-Clixml -Path .\TeamConfig.xml

# Clear all IP addresses that we can so that any pre-existing config doesn't break this.
Get-NetIPAddress | Where {$_.InterfaceAlias -eq $EthernetAdapterName } | Remove-NetIPAddress
# Setting a new IP & Gateway will fail if a gateway exists for this adapter. Remove existing
Remove-NetRoute -InterfaceAlias $EthernetAdapterName -DestinationPrefix 0.0.0.0/0 -Confirm:$false

# Set a new address 
New-NetIPAddress -InterfaceIndex $TeamConfig.Interface -IPAddress $TeamConfig.ADC0IP `
  -PrefixLength $TeamConfig.PrefixLength -DefaultGateway $TeamConfig.Gateway
# Set DNS config
Set-DnsClientServerAddress -InterfaceIndex $TeamConfig.Interface -ServerAddresses 127.0.0.1,$TeamConfig.UpstreamDNS

# Enable powershell remoting
Enable-PSRemoting -Force

# This line will rename the computer and force a restart.
Rename-Computer -NewName $TeamConfig.ADC0Name -Force -Restart
