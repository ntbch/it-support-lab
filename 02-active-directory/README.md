# Lab 2: Active Directory for helpdesk work

Build a small Windows domain (`lab.local`) in virtual machines and practise the account tasks a helpdesk handles every day: password resets, locked accounts, new joiners, leavers and group policy.

Time: about 4 hours, most of it Windows installation.

## What you need

- 16 GB RAM on the host is comfortable (8 GB works if you give each VM 3 GB), about 100 GB free disk.
- Free evaluation ISOs from the Microsoft Evaluation Center:
  - Windows Server 2022 (180-day evaluation)
  - Windows 11 Enterprise (90-day evaluation)

On Omarchy / Arch Linux, install the hypervisor once:

```bash
sudo pacman -S qemu-full virt-manager dnsmasq
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt "$USER"    # log out and back in afterwards
```

## 1. Domain controller (DC01)

1. In virt-manager create a VM from the Server ISO: 2 vCPU, 4 GB RAM, 60 GB disk, network "default" (NAT, 192.168.122.0/24).
2. Install "Windows Server 2022 Standard Evaluation (Desktop Experience)".
3. Copy the `scripts/` folder into the VM (shared folder or a small ISO), open PowerShell as Administrator and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\00-configure-network.ps1          # static IP 192.168.122.10, renames to DC01, restarts
.\01-promote-dc.ps1                 # installs AD DS + DNS, creates lab.local, restarts
.\02-create-ous-users.ps1           # OU per department, groups GG_<Dept>, 8 users from users.csv
.\04-lockout-and-gpo.ps1            # lockout after 5 bad passwords, 10-minute screen lock GPO
```

Check: open "Active Directory Users and Computers" and find the users under `Lab`.

## 2. Client (PC01)

1. Create a second VM from the Windows 11 ISO: 2 vCPU, 4 GB RAM, 64 GB disk, same "default" network.
2. Set its DNS server to `192.168.122.10` (Settings > Network > Edit DNS).
3. Check DNS: `nslookup lab.local` must answer from 192.168.122.10.
4. Join the domain: Settings > System > About > "Domain or workgroup" > `lab.local`, using `LAB\Administrator`. Restart.
5. Log in as `LAB\an.nguyen` with the initial password and set a new one.

## 3. Helpdesk exercises

Load the functions on DC01 with `. .\03-helpdesk-functions.ps1`. Do each task twice: once in the GUI (Active Directory Users and Computers), once with the function, and note the steps in `evidence/notes.md`.

| # | Situation | What you do |
|---|---|---|
| 1 | Chi Le calls: "my account is locked". Cause it yourself: type a wrong password 5 times on PC01. | `Get-LabLockedUsers`, check `badPwdCount` with `Get-LabUserInfo chi.le`, `Unlock-LabUser chi.le`. |
| 2 | Giang Hoang forgot her password. | Verify identity first (how would you do it in a real company?), then `Reset-LabPassword giang.hoang`. Log in on PC01 to confirm the forced change. |
| 3 | New joiner: "Minh Dang, Sales Executive, starts Monday." | Add a line to `users.csv`, re-run `02-create-ous-users.ps1`, confirm group membership. |
| 4 | Binh Tran needs access to the Accounting share. | `Add-LabUserToGroup binh.tran GG_Accounting`. Ask yourself whether the request needs a manager's approval. |
| 5 | Ha Vu leaves the company today. | `Disable-LabLeaver ha.vu`. Check the account is disabled, has no groups and sits in `OU=Disabled`. |
| 6 | "My screen doesn't lock automatically." | On PC01: `gpupdate /force`, `gpresult /r`; confirm "Lab - Screen lock 10 min" is applied. If not, check which OU the user is in. |
| 7 | PC01 says "the trust relationship between this workstation and the primary domain failed". | Reproduce by taking a VM snapshot of PC01, waiting until its machine password changes (or resetting the computer account in ADUC), then reverting the snapshot. Log in with a local admin and fix with `Test-ComputerSecureChannel -Repair -Credential LAB\Administrator`, or leave and re-join the domain. |

## Evidence

Save screenshots and `notes.md` in `evidence/`: the OU tree, a locked then unlocked account, `gpresult /r` output, and the disabled leaver.
