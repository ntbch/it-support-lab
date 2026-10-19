# Practice tickets

Create each ticket as the end user. Handle it as the technician. The "what to check" column is a hint; write your own follow-ups and solution in GLPI.

| # | Ticket (as the user writes it) | Category | What to check |
|---|---|---|---|
| 1 | "I can't log in to my computer, it says my password is wrong. I changed it last Friday." | Account & Access | Caps Lock, keyboard layout (VI/EN), account locked after failed attempts, password expiry. Reset only after verifying identity. |
| 2 | "Wifi on floor 5 keeps dropping, my laptop shows 'No internet, secured'." | Network | Other users affected? IP address (`ipconfig`): 169.254.x.x means no DHCP lease. Forget and rejoin the network, `ipconfig /release` and `/renew`, check DNS with `nslookup`. |
| 3 | "The printer on floor 3 prints blank pages." | Printer | Toner, print queue stuck (restart Print Spooler), test page from the printer itself vs. from the PC, driver. |
| 4 | "My laptop is very slow since this morning." | Hardware | Task Manager: CPU, RAM, disk at 100%? Startup apps, Windows Update running, free disk space, malware scan. |
| 5 | "Please install Zoom on my laptop for a client meeting at 2pm." | Software | Is it on the approved software list? Install from the official source, test audio and camera with the user. Set priority from the deadline. |
| 6 | "I accidentally deleted a folder from the shared drive." | Software | Which path, when? Restore from Previous Versions / backup, confirm with the user, note how to avoid it. |

After closing all six, look at the dashboard (Assistance > Statistics) and note how many tickets met the SLA.
