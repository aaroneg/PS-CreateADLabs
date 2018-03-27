Set-Location $PSScriptRoot
. .\Password-Generator.ps1
$Names=Import-Csv -Path .\Names.csv -Encoding UTF8
$NewHumans=@()
Foreach ($Name in $Names){
    $NewHumans+=[PSCustomObject]@{first=$Name.first;last=$Name.last;title=$Name.title;password=(New-Badpassword)}
}
$NewHumans|Export-Csv -Path .\NamesWithPasswords.csv -Encoding UTF8 -Verbose -NoTypeInformation
