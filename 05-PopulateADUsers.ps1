# You should know what these do by now.
Set-location $PSScriptRoot
$TeamConfig=Import-Clixml -Path .\TeamConfig.xml

# Import list from the CSV file generated earlier. UTF-8 for foreign (or possibly native to you) names.
$Users=Import-Csv -Path .\NamesWithPasswords.csv -Encoding UTF8

# Get the AD root of the current AD domain.
$ADRoot=([ADSI]"LDAP://RootDSE").rootDomainNamingContext

# Modify. "ContosoCorp" is only and example. 
$CompanyRoot=New-ADOrganizationalUnit -Name 'ContosoCorp' -Path "$ADRoot" -PassThru -ProtectedFromAccidentalDeletion $true
# Set where User accounts will be created. This will be a very simple structure
$UserOU=New-ADOrganizationalUnit -Name 'Users' -path $CompanyRoot.DistinguishedName -PassThru
# Iterate through each Human entry. Build some attributes from the CSV. Create the user account
Foreach ($human in $Users) {
		# You should probably learn how to index into strings if you're not sure what this does.
    $SamAccountName=$human.first[0]+$human.last
    $DisplayName=$human.first+" "+$human.last
    $Password=$human.password
    New-Aduser -GivenName $human.first -Surname $human.last -Division $human.title `
		-AccountPassword ($Password|Convertto-Securestring -AsPlainText -Force) `
    -Name $DisplayName -SamAccountName $SamAccountName -Title $human.title -Company 'Password Squirrel' `
    -ChangePasswordAtLogon:$false -Path $UserOU.DistinguishedName -enabled:$true
}
# Add group members once the accounts are created if you want more than just 'Administrator' in the domain admins group.
