# Creates OU=Lab with one OU and one security group per department, then the users from users.csv.
# Safe to re-run: existing OUs, groups and users are skipped.
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot "users.csv")
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

$domain = Get-ADDomain
$rootOu = "OU=Lab,$($domain.DistinguishedName)"
if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$rootOu'")) {
    New-ADOrganizationalUnit -Name "Lab" -Path $domain.DistinguishedName
    Write-Host "Created OU $rootOu"
}

$users = Import-Csv -Path $CsvPath
foreach ($dept in ($users.Department | Sort-Object -Unique)) {
    $ouDn = "OU=$dept,$rootOu"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouDn'")) {
        New-ADOrganizationalUnit -Name $dept -Path $rootOu
        Write-Host "Created OU $ouDn"
    }
    $group = "GG_$dept"
    if (-not (Get-ADGroup -Filter "Name -eq '$group'")) {
        New-ADGroup -Name $group -GroupScope Global -GroupCategory Security -Path $ouDn
        Write-Host "Created group $group"
    }
}

$initialPassword = Read-Host -AsSecureString "Initial password for new users (they must change it at first logon)"
foreach ($u in $users) {
    $sam = ("{0}.{1}" -f $u.FirstName, $u.LastName).ToLower()
    if (Get-ADUser -Filter "SamAccountName -eq '$sam'") {
        Write-Host "Skipped $sam (already exists)"
        continue
    }
    New-ADUser `
        -Name "$($u.FirstName) $($u.LastName)" `
        -GivenName $u.FirstName `
        -Surname $u.LastName `
        -SamAccountName $sam `
        -UserPrincipalName "$sam@$($domain.DNSRoot)" `
        -Department $u.Department `
        -Title $u.Title `
        -Path "OU=$($u.Department),$rootOu" `
        -AccountPassword $initialPassword `
        -ChangePasswordAtLogon $true `
        -Enabled $true
    Add-ADGroupMember -Identity "GG_$($u.Department)" -Members $sam
    Write-Host "Created $sam in $($u.Department)"
}
