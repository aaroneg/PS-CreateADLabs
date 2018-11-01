# Add the role to windows
Install-windowsfeature dhcp
# Create the DHCP security groups
netsh dhcp add securitygroups
# Get the hostname
$hostname=hostname
# Authorize the DHCP server in the domain
add-dhcpserverindc -dnsname $hostname
# Restart the dhcpserver service
Restart-service dhcpserver
Set-DhcpServerv4DnsSetting -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True

