# Lab 3: Small office network in Cisco Packet Tracer

Build a small office network with separate VLANs for staff, guests and servers, hand out addresses with DHCP, resolve names with DNS, then fix faults the way a helpdesk does when "the internet doesn't work".

Time: about 3 hours. Packet Tracer is free with a Cisco Networking Academy account (on Arch it is in the AUR as `packettracer`).

## Topology

```
          [R1 Cisco 2911]
                | G0/0 (trunk, router-on-a-stick)
                | G0/1
          [SW1 Cisco 2960]
   Fa0/1-10      Fa0/11-20      Fa0/24
   VLAN 10       VLAN 20        VLAN 30
   STAFF         GUEST          SERVERS
   PC-Staff1/2   Laptop-Guest   Server-DNS (192.168.30.10)
```

| VLAN | Name | Network | Gateway | Addresses |
|---|---|---|---|---|
| 10 | STAFF | 192.168.10.0/24 | 192.168.10.1 | DHCP from R1 |
| 20 | GUEST | 192.168.20.0/24 | 192.168.20.1 | DHCP from R1 |
| 30 | SERVERS | 192.168.30.0/24 | 192.168.30.1 | static |

## 1. Switch SW1

```
enable
configure terminal
hostname SW1
vlan 10
 name STAFF
vlan 20
 name GUEST
vlan 30
 name SERVERS
interface range fa0/1 - 10
 switchport mode access
 switchport access vlan 10
interface range fa0/11 - 20
 switchport mode access
 switchport access vlan 20
interface fa0/24
 switchport mode access
 switchport access vlan 30
interface gig0/1
 switchport mode trunk
end
write memory
```

## 2. Router R1

```
enable
configure terminal
hostname R1
interface g0/0
 no shutdown
interface g0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
interface g0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
interface g0/0.30
 encapsulation dot1Q 30
 ip address 192.168.30.1 255.255.255.0
ip dhcp excluded-address 192.168.10.1 192.168.10.20
ip dhcp excluded-address 192.168.20.1 192.168.20.20
ip dhcp pool STAFF
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 192.168.30.10
ip dhcp pool GUEST
 network 192.168.20.0 255.255.255.0
 default-router 192.168.20.1
 dns-server 192.168.30.10
! Guests may not reach the staff network
access-list 120 deny ip 192.168.20.0 0.0.0.255 192.168.10.0 0.0.0.255
access-list 120 permit ip any any
interface g0/0.20
 ip access-group 120 in
end
write memory
```

## 3. Server and clients

- Server-DNS: static IP 192.168.30.10/24, gateway 192.168.30.1. Services > DNS: on, add an A record `intranet.lab` → 192.168.30.10. Services > HTTP: on.
- PCs and the guest laptop: IP Configuration > DHCP.

Check from PC-Staff1: `ipconfig` shows 192.168.10.x, `ping 192.168.30.10` works, `nslookup intranet.lab` answers, the web browser opens `http://intranet.lab`. From the guest laptop, `ping` to a staff PC must fail and `intranet.lab` must still open.

## 4. Break and fix

Save a working copy first. Then introduce one fault at a time (or ask a friend to do it without telling you which), note the user's symptom, and find the cause with the commands below.

| Fault to introduce | What the user says | Where to look |
|---|---|---|
| Move PC-Staff2's port to VLAN 20 | "I can't open the staff files" | `ipconfig` (wrong subnet), `show vlan brief` |
| `shutdown` on `g0/0.10` | "No internet for everyone in the office" | `ping` gateway fails, `show ip interface brief` |
| Change the STAFF pool's `default-router` to 192.168.10.254 | "Internet stopped after I restarted" | `ipconfig` gateway, `show running-config \| section dhcp` |
| Turn off the DNS service | "Websites don't load but ping 192.168.30.10 works" | `nslookup intranet.lab` fails while `ping` by IP works |
| Unplug the trunk cable | "Nothing works" | link lights, `show interfaces trunk` |
| Set a static 169.254.x.x on a PC | "No internet, limited connectivity" | APIPA address means no DHCP lease: `ipconfig /renew` |

Useful commands: on PCs `ipconfig /all`, `ipconfig /renew`, `ping`, `tracert`, `nslookup`; on Cisco `show vlan brief`, `show ip interface brief`, `show interfaces trunk`, `show ip dhcp binding`, `show running-config`.

## Evidence

Save the `.pkt` file, screenshots of the working checks, and `evidence/notes.md` with each fault: symptom, commands you ran, cause, fix.
