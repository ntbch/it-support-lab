# Lab 4: IT Asset Management & Device Inventory with Snipe-IT

Snipe-IT is the industry-standard open-source IT asset management system. Companies and studios use it to track who has which laptop, manage device testing pools, assign accessories and monitors, record warranties, and perform physical inventory audits.

This lab directly addresses the device management and equipment tracking duties required by IT support positions (such as Gameloft's hardware lockbox and test device tracking).

Estimated time: 2–3 hours.

## 1. Quick Start

```bash
cd 04-asset-management-snipeit
cp .env.example .env
# put the generated key on the APP_KEY= line and change both DB passwords
docker run --rm snipe/snipe-it:latest php artisan key:generate --show
docker compose up -d

Open `http://localhost:8081` in your browser.

The first time you load the page, Snipe-IT runs the setup wizard:
1. **Pre-Flight Check**: confirms PHP, database connection, and storage permissions are ready.
2. **Create Database Tables**: click Next to run migrations automatically.
3. **Create Your Admin User**:
   - Site Name: `Studio IT Asset Management`
   - Default Currency: `VND`
   - First / Last Name: `Nguyen Tung Bach`
   - Email: `nguyenbachtung181@gmail.com`
   - Username: `admin`
   - Password: (set a secure password)

## 2. Setting Up the Asset Structure

Log in as the admin user and configure the baseline asset hierarchy:

1. **Locations**:
   - `Lilama 10 - Floor 3 (Game Production)`
   - `Lilama 10 - Floor 4 (HQ & Admin)`
   - `IT Storage / Hardware Lockbox`
2. **Asset Categories**:
   - `Laptops & Workstations` (Type: Asset)
   - `Mobile Test Devices` (Type: Asset — required for game testing pools)
   - `Monitors & Displays` (Type: Asset)
   - `Peripherals` (Type: Accessory)
3. **Status Labels**:
   - `Ready to Deploy` (Deployable)
   - `Checked Out` (Deployable)
   - `In Repair / Testing` (Undeployable)
   - `Archived / Decommissioned` (Archived)
4. **Manufacturers & Models**:
   - Manufacturer: `Apple`, `Samsung`, `Dell`, `Lenovo`
   - Models:
     - `Dell Latitude 5420` (Category: Laptops)
     - `Samsung Galaxy S22` (Category: Mobile Test Devices)
     - `iPhone 13 128GB` (Category: Mobile Test Devices)
     - `Dell P2419H 24-inch` (Category: Monitors)

## 3. Practical Exercises

Follow the step-by-step scenarios in `scenarios.md`:
- Check-out of mobile test devices to QA game testers
- New employee laptop and peripheral onboarding
- Device return, physical condition inspection, and check-in to lockbox
- Quarterly physical audit reconciliation
- Handling a damaged device workflow

## 4. Evidence to Collect

Save in an `evidence/` folder:
- Screenshot of the Dashboard showing total assets, checked-out devices, and status distribution.
- Screenshot of an Asset detail page (e.g., a test phone) showing checkout history and audit logs.
- Generated Asset Tag / QR code label preview.

## 5. Teardown

```bash
docker compose down        # preserves data in Docker volumes
docker compose down -v     # resets database and uploaded data
```
