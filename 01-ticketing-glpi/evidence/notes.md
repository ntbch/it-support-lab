# Lab 1 evidence: GLPI helpdesk

Run on 2026-10-19 with GLPI 12.0.0 (Docker, `glpi/glpi:latest` + MariaDB 11.4).

## Setup

- Default accounts (`glpi`, `tech`, `normal`, `post-only`) given new passwords.
- Locations: Hanoi Office - Floor 3, Hanoi Office - Floor 5.
- ITIL categories: Hardware, Software, Network, Account & Access, Printer.
- Users: 3 end users (Self-Service profile) and 1 technician (`bach.tech`, Technician profile).
- Assets: laptops LT-001 to LT-003, each linked to its user and location; printer PRN-F3-01 on floor 3.
- SLA "Standard Incident SLA": time to own 1 hour, time to resolve 8 hours, applied to every ticket.

The configuration was done through the GLPI REST API (`apirest.php`, enabled with `bin/console config:set enable_api 1`); ticket approval and the screenshots were done in the web UI.

## Tickets

Each ticket was opened by the end user, then assigned, categorised, prioritised and linked to its asset by the technician, who asked a question in a follow-up, logged tasks with time spent, wrote a solution, and had the user approve it (status Closed).

The scenarios are role-played practice tickets: the users and fixes are simulated, not real incidents.

| # | User report | Category / priority | Cause | Fix |
|---|---|---|---|---|
| 1 | Can't log in, password "wrong" | Account & Access / High | Account locked after 5 failed attempts | Verified identity first (employee ID + department), unlocked, temporary password with forced change |
| 2 | Wi-Fi floor 5 drops, "No internet, secured" | Network / High | `ipconfig` showed 169.254.x.x (APIPA): DHCP pool for the floor full; several users affected | Escalated to network admin, scope extended, `ipconfig /renew`, checked DNS with `nslookup` |
| 3 | Floor 3 printer prints blank pages | Printer / Medium | Printer's own test page also blank: new toner cartridge still had its sealing tape | Removed tape, reseated cartridge, test page + PC print OK |
| 4 | Laptop very slow | Hardware / Medium | Disk at 100%: Windows Update with 6 GB free and 9 startup apps | Finished update, freed 21 GB, disabled 6 startup apps with user's agreement |
| 5 | Install Zoom before a 2pm meeting | Software / High | Request | Checked approved-software list, installed from official installer, tested audio/mic/camera |
| 6 | Deleted a folder on the shared drive | Software / High | Network share has no Recycle Bin | Restored from the 07:00 shadow copy (Previous Versions), user confirmed 142 files |

## Knowledge base

- KB #2 "Printer prints blank pages" (from ticket 3)
- KB #3 "Wi-Fi shows 'No internet, secured' / IP 169.254.x.x" (from ticket 2)

## Screenshots

- `01-ticket-list.png`: all 6 tickets closed, with category, priority, requester, technician and SLA time to resolve
- `02-ticket-2-wifi-timeline.png`, `03-ticket-1-account-locked.png`: full ticket timelines
- `04-kb-printer-blank-pages.png`, `05-kb-wifi-apipa.png`: knowledge base articles
- `06-assets-computers.png`: laptop inventory

## What I would say in an interview

- Verify identity before resetting a password, never reset just because someone asks by phone or chat.
- 169.254.x.x means no DHCP lease. If several users are affected, it is the network, not the laptop: escalate instead of reinstalling drivers.
- A test page from the device itself splits "printer problem" from "PC/driver problem" in one step.
