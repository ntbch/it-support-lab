# Practice Scenarios: Game Studio IT Inventory

Work through each scenario in Snipe-IT. Record the asset tags and notes in your log.

### Scenario 1: New Mobile Testing Fleet Onboarding
1. Create 3 new assets under category **Mobile Test Devices**:
   - Asset Tag: `MBL-001` | Samsung Galaxy S22 | Serial: `R5CR10ABCDE` | Location: `IT Storage / Hardware Lockbox` | Status: `Ready to Deploy`
   - Asset Tag: `MBL-002` | iPhone 13 | Serial: `F2LLK099XYZ` | Location: `IT Storage / Hardware Lockbox` | Status: `Ready to Deploy`
   - Asset Tag: `MBL-003` | Xiaomi Redmi Note 11 | Serial: `XM987654321` | Location: `IT Storage / Hardware Lockbox` | Status: `Ready to Deploy`
2. Add custom fields if desired (OS version, IMEI, SIM Card Number).

### Scenario 2: Checkout to QA Production Team
- A QA Game Tester (create user: `Tran Van Nam`, Department: `QA Game Studio`) requests `MBL-001` and `MBL-002` for testing the upcoming game release for 3 days.
- **Action**: Check out both devices to `Tran Van Nam` with an expected check-in date.
- Confirm both assets now reflect status `Checked Out`.

### Scenario 3: Device Return & Condition Inspection
- `Tran Van Nam` returns `MBL-001` in good condition, but reports `MBL-002` suffered a cracked back glass during drop testing.
- **Action**:
  - Check in `MBL-001` back to `IT Storage / Hardware Lockbox` as `Ready to Deploy`.
  - Check in `MBL-002`, immediately change status label to `In Repair / Testing`, and add a maintenance record describing the cracked back glass and estimate for repair.

### Scenario 4: Hardware Audit
- Conduct an asset audit on `MBL-001`:
  - Open `MBL-001` -> Click **Audit**.
  - Set next audit date to 6 months from now and verify physical location matches `Hardware Lockbox`.
  - Confirm audit record appears under the **Audit Log** tab.
