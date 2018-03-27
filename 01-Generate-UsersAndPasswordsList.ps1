# Change to the script location
Set-Location $PSScriptRoot

# Source the Password Generator function from it's file
. .\Password-Generator.ps1

# Import our 'Names.csv' file, using UTF-8 in case there are foreign names
$Names=Import-Csv -Path .\Names.csv -Encoding UTF8
# Create an empty array of humans 
$NewHumans=@()
# Iterate through each name and generate a password for them
Foreach ($Name in $Names){
    $NewHumans+=[PSCustomObject]@{first=$Name.first;last=$Name.last;title=$Name.title;password=(New-Badpassword)}
}
# Save the new CSV, using UTF-8 in case there are foreign names.
$NewHumans|Export-Csv -Path .\NamesWithPasswords.csv -Encoding UTF8 -Verbose -NoTypeInformation
