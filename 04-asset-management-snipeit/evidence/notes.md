# Lab 4 evidence: Snipe-IT asset management

Run on 2026-10-19 with Snipe-IT v8.8.0 (Docker, `snipe/snipe-it:latest` + MariaDB 10.11).

## Setup

- Setup wizard: site "Studio IT Asset Management", currency VND, admin account.
- Locations: Lilama 10 - Floor 3 (Game Production), Lilama 10 - Floor 4 (HQ & Admin), IT Storage / Hardware Lockbox.
- Categories: Laptops & Workstations, Mobile Test Devices, Monitors & Displays (assets); Peripherals (accessories).
- Status labels: Ready to Deploy, In Repair / Testing (undeployable), Archived / Decommissioned.
- Models: Samsung Galaxy S22, iPhone 13 128GB, Xiaomi Redmi Note 11, Dell Latitude 5420, Dell P2419H.

Structure and scenario steps went through the Snipe-IT REST API (`/api/v1`, token created for the admin user); the wizard and screenshots were done in the web UI.

## Scenarios (from `../scenarios.md`)

The users and devices are lab data, not a real fleet.

| # | Scenario | What was done | Result |
|---|---|---|---|
| 1 | Mobile test fleet intake | Created MBL-001 (Galaxy S22), MBL-002 (iPhone 13), MBL-003 (Redmi Note 11) with serials, in the lockbox, Ready to Deploy. Also LT-101 laptop and MON-101 monitor on floor 4. | 5 assets in inventory |
| 2 | Checkout to QA | Created user Nam Tran Van (QA Game Studio, floor 3). Checked out MBL-001 and MBL-002 with expected check-in in 3 days and a note on the purpose. | `01-test-phones-checked-out-to-qa.png` |
| 3 | Return and inspection | MBL-001 checked in to the lockbox as Ready to Deploy after inspection. MBL-002 came back with cracked back glass: checked in as In Repair / Testing and a Repair maintenance record opened with the service supplier. | `02-asset-list-after-checkin.png`, `03-mbl-002-damaged-in-repair.png`, `05-maintenance-record.png` |
| 4 | Audit | Audited MBL-001 in the lockbox, next audit in 6 months. | `04-mbl-001-history-and-audit.png` shows create, checkout, checkin, audit |

`06-dashboard.png` shows the totals after all scenarios.

## What I would say in an interview

- Every device that leaves the lockbox is checked out to a named person with an expected return date, so overdue devices show up on their own.
- A damaged device is checked in to an undeployable status, not back into the pool, and gets a maintenance record so the repair cost and history stay with the asset.
- Audits record that someone physically saw the device in its location on a given date.
