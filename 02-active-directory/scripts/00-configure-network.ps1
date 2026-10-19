# Run on the future domain controller, as Administrator, before promoting it.
# Gives the server a static IP on the libvirt default network and renames it.
param(
    [string]$IPAddress = "192.168.122.10",
    [int]$PrefixLength = 24,
    [string]$Gateway = "192.168.122.1",
    [string]$NewName = "DC01"
)

$ErrorActionPreference = "Stop"
$adapter = Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object -First 1
if (-not $adapter) { throw "No network adapter is up." }
$index = $adapter.ifIndex

Set-NetIPInterface -InterfaceIndex $index -Dhcp Disabled
Get-NetIPAddress -InterfaceIndex $index -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Remove-NetIPAddress -Confirm:$false
Remove-NetRoute -InterfaceIndex $index -DestinationPrefix "0.0.0.0/0" -Confirm:$false -ErrorAction SilentlyContinue

New-NetIPAddress -InterfaceIndex $index -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $Gateway | Out-Null
# The DC will run DNS itself once promoted.
Set-DnsClientServerAddress -InterfaceIndex $index -ServerAddresses "127.0.0.1"

Write-Host "Static IP $IPAddress/$PrefixLength set on $($adapter.Name). Renaming to $NewName and restarting..."
Rename-Computer -NewName $NewName -Restart
