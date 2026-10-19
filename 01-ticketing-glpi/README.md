# Lab 1: IT helpdesk ticketing with GLPI

GLPI is an open-source IT service management tool used by many companies for helpdesk tickets and IT asset inventory. In this lab you run it locally, configure it like a small company helpdesk, and work through realistic tickets from first contact to closure.

Time: about 3 hours.

## 1. Start GLPI

```bash
cp .env.example .env        # then change both passwords
docker compose up -d
```

Open http://localhost:8080. The first start installs GLPI automatically (about 30 seconds).

Default accounts created by the installer:

| Login | Password | Profile |
|---|---|---|
| `glpi` | `glpi` | Super-Admin |
| `tech` | `tech` | Technician |
| `normal` | `normal` | Normal user |
| `post-only` | `postonly` | Self-service (end user) |

GLPI warns about these default passwords on the home page. Change them under Administration > Users before you start.

## 2. Set up the helpdesk

Log in as `glpi` and do the following. Take a screenshot of each result for `evidence/`. The compose file pulls the latest GLPI (12.0 when this was written); if a menu path below has moved, use the search box at the top of GLPI.

1. Create an entity or keep the root entity, then create 2 locations: `Hanoi Office - Floor 3`, `Hanoi Office - Floor 5`.
2. Create ticket categories (Setup > Dropdowns > ITIL categories): `Hardware`, `Software`, `Network`, `Account & Access`, `Printer`.
3. Create 3 end users (Administration > Users) with a location each, plus one technician account for yourself.
4. Add a few assets (Assets > Computers, Printers): 3 laptops and 1 printer, each linked to a user and location.
5. Create an SLA (Setup > Services levels): time to own 1 hour, time to resolve 8 hours, and attach it to the `Incident` type.

## 3. Work the tickets

Open each ticket in `tickets.md` while logged in as `post-only` (the end user's view). Then log in as your technician account and handle it:

- assign it to yourself and set category, priority and the linked asset;
- add a follow-up asking the user for what you need;
- add tasks with the time you spent;
- write a solution and close the ticket.

For two of them, also write a Knowledge Base article (Tools > Knowledge base) that another technician could follow next time.

## 4. Evidence for your CV and interviews

Save in `evidence/`:

- the ticket list showing all tickets closed, with categories and SLA status;
- one full ticket timeline (follow-ups, tasks, solution);
- your two Knowledge Base articles (export or screenshot).

## 5. Stop and clean up

```bash
docker compose down        # keeps data
docker compose down -v     # deletes everything
```
