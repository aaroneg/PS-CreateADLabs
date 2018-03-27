# Go to the script path
Set-Location $PSScriptRoot
# Import configuration from XML file on disk
$TeamConfig=Import-Clixml -Path .\TeamConfig.xml

# Configure the parent DNS servers
Set-DnsServerForwarder -IPAddress $TeamConfig.UpstreamDNS,8.8.8.8
