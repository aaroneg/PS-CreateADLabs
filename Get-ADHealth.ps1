<#
    .NOTES
    Author: Aaron Glenn
    Q: What does this do?
    A: It attempts to validate your AD health to the best of the author's ability

    Q: What format does it output?
    A: Markdown

    Q: Why Markdown?
    A: It's dead simple and I like it

    Q: I don't have any use for markdown. Can I easily adapt this to some other format?
    A: Sigh. Fine. https://social.technet.microsoft.com/wiki/contents/articles/30591.convert-markdown-to-html-using-powershell.aspx
    A: https://pandoc.org/getting-started.html

#>
$Report=@()
Clear-Host
$ADForest = [system.directoryservices.activedirectory.Forest]::GetCurrentForest()
$Report+="# Forest"
$Report+="* Forest Name:                $($ADForest.Name)"
$Report+="`n## Forest Role Owners"
$Report+="* Forest Schema Role Owner:   $($ADForest.SchemaRoleOwner)"
$Report+="* Forest Naming Role Owner:   $($ADForest.NamingRoleOwner)"
$SchemaRoleOwnerContactable=Test-Connection($ADForest.SchemaRoleOwner) -Count 1 -Quiet
$NamingRoleOwnerContactable=Test-Connection($ADForest.NamingRoleOwner) -Count 1 -Quiet
$Report+="`n## Role Owner Online"
$Report+="* Schema Role Owner Contactable: **$SchemaRoleOwnerContactable**"
$Report+="* Naming Role Owner Contactable: **$NamingRoleOwnerContactable**"

$Report+="`n## Forest Domains"
foreach ($ForestDomain in $ADForest.Domains) {
    $Report+="* $($ForestDomain.Name)"
}

$ADDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Report+="`n# Current Domain"
$Report+="* Domain Name:                    $($ADDomain.Name)"
$Report+="`n## Domain Role Owners"
$Report+="* Domain PDC Emulator Owner:      $($Addomain.PdcRoleOwner)"
$Report+="* Domain Rid Role Owner:          $($Addomain.RidRoleOwner)"
$Report+="* Domain Infrastructure Owner:    $($Addomain.InfrastructureRoleOwner)"
$PDCContactable=Test-Connection($ADDomain.PdcRoleOwner) -Count 1 -Quiet
$RIDContactable=Test-Connection($ADDomain.RidRoleOwner) -Count 1 -Quiet
$InfraContactable=Test-Connection($ADDomain.InfrastructureRoleOwner) -Count 1 -Quiet
$Report+="`n## Domain Role Owner Online"
$Report+="* PDC contactable : **$PDCContactable**"
$Report+="* RID contactable : **$RIDContactable**"
$Report+="* INF contactable : **$InfraContactable**"
$Report+="`n## Domain Controllers"
$ADControllers=(Get-ADDomain).ReplicaDirectoryServers
Foreach ($ADController in $ADControllers) {
    if(Test-Connection $ADController -Count 1 -Quiet){$Status="**Online**"}else{$Status="**Offline**"}
    $Report+="* "+$ADController+" : "+$Status
}

$Report+="`n## NetLogon Services"
Foreach ($ADController in $ADControllers) {
    $Status=(Get-Service -ComputerName $ADController -Name Netlogon -ErrorAction SilentlyContinue).Status 
    $Report+="* "+$ADController+" : **"+$Status+"**"
}

$Report+="`n## NTDS Services"
Foreach ($ADController in $ADControllers) {
    $Status=(Get-Service -ComputerName $ADController -Name NTDS -ErrorAction SilentlyContinue).Status 
    $Report+="* "+$ADController+" : **"+$Status+"**"
}

$Report+="`n## DNS Services"
Foreach ($ADController in $ADControllers) {
    $Status=(Get-Service -ComputerName $ADController -Name DNS -ErrorAction SilentlyContinue).Status 
    $Report+="* "+$ADController+" : **"+$Status+"**"
}


$Report+="`n## KDC Services"
Foreach ($ADController in $ADControllers) {
    $Status=(Get-Service -ComputerName $ADController -Name KDC -ErrorAction SilentlyContinue).Status 
    $Report+="* "+$ADController+" : **"+$Status+"**"
}


$Report+="`n## ADWS Services"
Foreach ($ADController in $ADControllers) {
    $Status=(Get-Service -ComputerName $ADController -Name ADWS -ErrorAction SilentlyContinue).Status 
    $Report+="* "+$ADController+" : **"+$Status+"**"
}

$Report+="`n## Secure Channel to Domain Controllers"
Foreach ($ADController in $ADControllers) {
    $Status=Test-ComputerSecureChannel -Server $ADController
    $Report+="* "+$ADController+" : **"+$Status+"**"
}

$Report+="`n ## Current Replication failures across the domain"
(Get-ADReplicationFailure -Scope Domain).Count
$Report|Set-Clipboard
$Report|Out-File $PSScriptRoot\ADHealth.md -Encoding utf8
