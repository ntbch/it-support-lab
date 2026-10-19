# Installs AD DS + DNS and creates the forest lab.local. The server restarts when done.
param(
    [string]$DomainName = "lab.local",
    [string]$NetbiosName = "LAB"
)

$ErrorActionPreference = "Stop"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$dsrm = Read-Host -AsSecureString "Directory Services Restore Mode (DSRM) password"
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -InstallDns `
    -SafeModeAdministratorPassword $dsrm `
    -Force
