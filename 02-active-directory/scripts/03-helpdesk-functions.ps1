# Everyday helpdesk tasks. Load them into your session with:
#   . .\03-helpdesk-functions.ps1
# then run e.g.  Get-LabUserInfo an.nguyen

Import-Module ActiveDirectory

function Get-LabUserInfo {
    param([Parameter(Mandatory)][string]$User)
    Get-ADUser -Identity $User -Properties Enabled, LockedOut, badPwdCount, PasswordLastSet, LastLogonDate, Department, MemberOf |
        Select-Object Name, SamAccountName, Department, Enabled, LockedOut, badPwdCount, PasswordLastSet, LastLogonDate,
            @{ Name = "Groups"; Expression = { ($_.MemberOf | ForEach-Object { ($_ -split ",")[0] -replace "^CN=" }) -join ", " } }
}

function Get-LabLockedUsers {
    Search-ADAccount -LockedOut | Select-Object Name, SamAccountName, LastLogonDate
}

function Unlock-LabUser {
    param([Parameter(Mandatory)][string]$User)
    Unlock-ADAccount -Identity $User
    Write-Host "Unlocked $User"
}

function Reset-LabPassword {
    # Verify the caller's identity BEFORE running this.
    param([Parameter(Mandatory)][string]$User)
    $temp = Read-Host -AsSecureString "Temporary password for $User"
    Set-ADAccountPassword -Identity $User -Reset -NewPassword $temp
    Set-ADUser -Identity $User -ChangePasswordAtLogon $true
    Unlock-ADAccount -Identity $User
    Write-Host "Password reset for $User; they must change it at next logon."
}

function Add-LabUserToGroup {
    param([Parameter(Mandatory)][string]$User, [Parameter(Mandatory)][string]$Group)
    Add-ADGroupMember -Identity $Group -Members $User
    Write-Host "Added $User to $Group"
}

function Disable-LabLeaver {
    # Offboarding: disable the account, remove group memberships, move it to OU=Disabled.
    param([Parameter(Mandatory)][string]$User)
    $account = Get-ADUser -Identity $User -Properties MemberOf
    Disable-ADAccount -Identity $account
    foreach ($groupDn in $account.MemberOf) {
        Remove-ADGroupMember -Identity $groupDn -Members $account -Confirm:$false
    }
    $domainDn = (Get-ADDomain).DistinguishedName
    $disabledOu = "OU=Disabled,OU=Lab,$domainDn"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$disabledOu'")) {
        New-ADOrganizationalUnit -Name "Disabled" -Path "OU=Lab,$domainDn"
    }
    Move-ADObject -Identity $account.DistinguishedName -TargetPath $disabledOu
    Write-Host "Disabled $User, removed $($account.MemberOf.Count) group memberships, moved to $disabledOu"
}
