# Account lockout policy for the domain, plus a GPO that locks the screen after 10 minutes for OU=Lab.
$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory
Import-Module GroupPolicy

$domain = Get-ADDomain
Set-ADDefaultDomainPasswordPolicy -Identity $domain.DNSRoot `
    -LockoutThreshold 5 `
    -LockoutDuration "00:15:00" `
    -LockoutObservationWindow "00:15:00"
Write-Host "Lockout policy: 5 bad attempts, locked for 15 minutes."

$gpoName = "Lab - Screen lock 10 min"
$gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
if (-not $gpo) { $gpo = New-GPO -Name $gpoName }

$key = "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop"
Set-GPRegistryValue -Name $gpoName -Key $key -ValueName "ScreenSaveActive" -Type String -Value "1" | Out-Null
Set-GPRegistryValue -Name $gpoName -Key $key -ValueName "ScreenSaverIsSecure" -Type String -Value "1" | Out-Null
Set-GPRegistryValue -Name $gpoName -Key $key -ValueName "ScreenSaveTimeOut" -Type String -Value "600" | Out-Null

$target = "OU=Lab,$($domain.DistinguishedName)"
if (-not ((Get-GPInheritance -Target $target).GpoLinks | Where-Object DisplayName -eq $gpoName)) {
    New-GPLink -Name $gpoName -Target $target | Out-Null
}
Write-Host "GPO '$gpoName' linked to $target. On the client run: gpupdate /force, then gpresult /r"
