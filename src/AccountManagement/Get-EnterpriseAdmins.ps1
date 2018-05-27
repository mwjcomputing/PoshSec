function Get-EnterpriseAdmins {
    <#
    .SYNOPSIS
    Obtains the list of Enterprise admins.

    .DESCRIPTION
    Obtains the list of Enterprise admins for the current or specified domain.

    .EXAMPLE
    PS> Get-EnterpriseAdmins
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',Justification='Group name is Enterprise Admins')]
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage="Name of domain to run query against.")]
        [string]$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    )


    #Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    $CurrentDomain = [ADSI]"LDAP://$Domain"
    Write-Debug -Message "Set ADSI Connection to $CurrentDomain"
    $DN = $CurrentDomain.DistinguishedName
    Write-Debug -Message "Set Distinguished Name to $DN"
    $EnterpriseAdmins = [ADSI]"LDAP://cn=Enterprise Admins,cn=Users,$DN"
    Write-Debug -Message "Set Domain Admin string to $EnterpriseAdmins"

    Foreach($Member in $EnterpriseAdmins.Member) {
        $MemberDN = [ADSI]"LDAP://$Member"
        Write-Debug -Message "MemberDN: $MemberDN"
        $HashTable = [PSCustomObject]@{
            DisplayName = $MemberDN.DisplayName | ForEach-Object {$_}
            SamAccountName = $MemberDN.SamAccountName | ForEach-Object {$_}
            DistinguishedName = $MemberDN.DistinguishedName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }
}