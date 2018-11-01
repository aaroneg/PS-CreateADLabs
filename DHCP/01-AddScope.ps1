# Set up the scope you want to create
$ScopeArguments=@{
  StartRange="192.168.0.50"
  EndRange="192.168.0.99"
  Name="Scope0"
  Description="Main Scope"
  SubnetMask="255.255.255.0"
  ActivatePolicies=$True
  State="Active"
  Type="Dhcp"
}
Add-DHCPServerv4Scope @ScopeArguments -Verbose 

# Set the default gateway on the scope
Set-DhcpServerv4OptionValue -OptionID 3 -Value 192.168.0.1 -ScopeID 192.168.0.0
# Set the dns server & Name on the scope
Set-DhcpServerv4OptionValue -DnsDomain corp.contoso.com -DnsServer 192.168.0.2
