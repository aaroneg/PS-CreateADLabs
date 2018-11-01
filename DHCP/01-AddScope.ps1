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
