# Add the role to windows
Install-windowsfeature dhcp
# Get the hostname
$hostname=hostname
# Authorize the DHCP server in the domain
add-dhcpserverindc -dnsname $hostname
