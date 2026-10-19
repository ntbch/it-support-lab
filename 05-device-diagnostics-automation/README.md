# Lab 5: Workstation & Mobile Device Diagnostic Automation

In enterprise helpdesk and studio IT support, resolving user issues quickly and maintaining fleets of hardware requires automation. Instead of manually asking users for IP addresses, disk usage, or device specifications, technicians use diagnostic scripts to capture actionable system state in seconds.

This lab covers:
1. **Linux Workstation Health Collector** (`pc-health-check.sh`): Generates Markdown ticket diagnostic attachments covering CPU, memory, disk, network gateway/DNS, and top resource-hogging processes.
2. **Windows Workstation Health Collector** (`pc-health-check.ps1`): PowerShell equivalent collecting WMI/CIM hardware specs, disk volumes, network configuration, and active processes.
3. **Android Device QA Audit Tool** (`android-device-audit.sh`): Interacts with Android test phones via Android Debug Bridge (ADB), extracting hardware serials, OS build versions, battery health, and storage availability.

Estimated time: 1.5–2 hours.

## 1. Workstation Diagnostic Tools

### Linux Diagnostic Collection
Run on Linux workstations or servers to collect instant diagnostics:
```bash
./pc-health-check.sh ticket-1042-diagnostic.md
```
Open `ticket-1042-diagnostic.md` to see the formatted report ready to be attached to GLPI or Jira tickets.

### Windows Diagnostic Collection
Run in an elevated PowerShell session on Windows client machines:
```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\pc-health-check.ps1 -OutputFile "ticket-1042-windows.md"
```

## 2. Mobile Device Testing & Audit Tool (Studio IT Hardware Service)

For game and mobile app studios (such as Gameloft), tracking and maintaining the mobile testing device pool is a core helpdesk responsibility.

Run the tool:
```bash
# With an actual Android device connected via USB (with USB Debugging enabled):
./android-device-audit.sh

# Or in simulation / self-test mode without physical hardware:
./android-device-audit.sh --mock
```

It prints a formatted hardware spec card and exports `mobile-device-inventory.json` with hardware specs, OS version, and battery metrics.

## 3. Exercises & Practice Scenarios

1. **Simulate a Slow PC Ticket:** Run `pc-health-check.sh` on your local system. Identify which process is consuming the highest CPU and memory, and draft a response to an end-user explaining what is consuming their resources.
2. **Network Connectivity Failure Simulation:** Disconnect network connectivity (or block DNS temporarily), run the diagnostic check, and observe how the connectivity table immediately pinpoints whether local gateway, public internet, or DNS failed.
3. **Test Device Intake Audit:** Run `android-device-audit.sh --mock` and attach the output card to a test record in Snipe-IT (Lab 4) to verify end-to-end integration between asset management and diagnostic scripts.
