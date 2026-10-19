# Lab 5 evidence: diagnostic scripts

Run on 2026-10-19.

## What ran, and where

| File | Script | Where it ran | Result |
|---|---|---|---|
| `01-linux-workstation-report.md` | `pc-health-check.sh` | Real laptop (Omarchy / Arch Linux) | Full report: CPU, RAM, disk, IP, gateway, internet, DNS, top processes |
| `02-container-network-ok.md` | `pc-health-check.sh` | Debian container on the Docker bridge network | All connectivity checks PASS |
| `03-container-network-down.md` | `pc-health-check.sh` | Same container after `docker network disconnect bridge` | No IPv4 address, gateway None, internet and DNS FAIL |
| `04-android-audit-MOCK-card.txt`, `04-android-audit-MOCK.json` | `android-device-audit.sh --mock` | No phone connected and no `adb` installed | **Simulated data**, shows the output format only. Not a real device audit |

`pc-health-check.ps1` (Windows) was only checked for syntax with PowerShell 7; it has not been run on a Windows machine yet.

## Bug found during the "network down" exercise

The first run with the network disconnected printed an empty IP address marked "Assigned" and an empty gateway, because `awk` returns nothing with exit code 0, so the `|| echo "None"` fallback never ran. Fixed: an empty address now reports `MISSING (no IPv4 address)`, a `169.254.x.x` address reports `APIPA (no DHCP lease)`, and an empty gateway reports `None`. Reports 01 to 03 were regenerated with the fixed script.

## Reading the network table

| Local IP | Gateway | Internet | DNS | Likely cause |
|---|---|---|---|---|
| Missing | FAIL | FAIL | FAIL | Cable / Wi-Fi not connected, adapter disabled |
| 169.254.x.x | FAIL | FAIL | FAIL | No DHCP lease (DHCP server or pool problem) |
| Assigned | PASS | FAIL | FAIL | Problem past the local router (ISP / upstream) |
| Assigned | PASS | PASS | FAIL | DNS server problem: sites fail by name but IPs work |
