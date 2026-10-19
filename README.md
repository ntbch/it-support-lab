# IT support lab

Hands-on practice for IT helpdesk work: a ticketing system, IT asset management, diagnostic scripts, a Windows domain and a small office network. Each lab has a step-by-step guide, ready-made configs or scripts, and exercises written as real user requests.

| Lab | What it covers | Status |
|---|---|---|
| [01-ticketing-glpi](01-ticketing-glpi/) | GLPI helpdesk: categories, SLA, assets, 6 tickets handled end to end, 2 knowledge base articles | Done, see [evidence](01-ticketing-glpi/evidence/notes.md) |
| [04-asset-management-snipeit](04-asset-management-snipeit/) | Snipe-IT: inventory of test phones, laptops and monitors, check-out/check-in, damaged-device repair record, audit | Done, see [evidence](04-asset-management-snipeit/evidence/notes.md) |
| [05-device-diagnostics-automation](05-device-diagnostics-automation/) | Bash and PowerShell workstation health reports, Android test-device audit over ADB | Linux script done; Windows script not yet run on Windows; Android audit only in mock mode. See [evidence](05-device-diagnostics-automation/evidence/notes.md) |
| [02-active-directory](02-active-directory/) | Windows Server domain: password resets, locked accounts, joiners and leavers, Group Policy | Guide and scripts ready, not run yet (needs QEMU/virt-manager and Windows evaluation ISOs) |
| [03-network-packet-tracer](03-network-packet-tracer/) | VLANs, DHCP, DNS and an ACL in Cisco Packet Tracer, then 6 network faults | Guide and configs ready, not run yet (needs Cisco Packet Tracer) |

Each lab's `evidence/` folder holds screenshots and `notes.md`: what the user reported, what was checked, the cause, and the fix. Users, devices and incidents in the labs are practice data.

Run order if starting fresh: 01 and 04 (Docker only), then 05, 03, 02.
