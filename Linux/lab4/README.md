# Lab 4: Demonstrate the differences between using the hosts file and DNS for URL resolution. Modify the hosts file to resolve a URL to a specific IP address, then configure BIND9 as a DNS solution to resolve wildcard subdomains and verify resolution using dig or nslookup (e.g. mariam-->192.168.10.1)
## overview Hosts File vs. DNS for URL Resolution
This lab demonstrates the differences between using the hosts file and a DNS server (BIND9) for resolving URLs to IP addresses. The focus is on mapping a hostname (mariam) to an IP address (192.168.10.1) using both methods, and configuring BIND9 to handle wildcard subdomains.
## Understand the Key Concepts
### 1- Hosts File:
- The hosts file is a local file used for mapping hostnames to IP addresses.
- It overrides DNS lookups and is system-specific.
### 2- DNS (BIND9):
- BIND9 is a popular DNS server that can handle advanced domain name resolution.
- It allows for centralized domain management and supports wildcard subdomains.
## Steps:
### Step 1: Modify the Hosts File
#### 1-Open the hosts file:
```
sudo nano /etc/hosts
```
#### 2- Add the following entry to map mariam to 192.168.10.1:
```
192.168.10.1 mariam
```
#### 3- Save and exit the editor.
#### 4- Test the resolution using ping:
```
ping mariam
```
If successful, the IP address 192.168.10.1 will respond.
### Step 2: Install and Configure BIND9
#### 1- Install BIND9:
```
sudo apt update
sudo apt install bind9 -y
```
#### 2- Configure a Zone File for Your Domain:
- Open the named.conf.local file:
```
sudo nano /etc/bind/named.conf.local
```
- Add the following zone configuration:
```
zone "mariam" {
    type master;
    file "/etc/bind/db.mariam";
};
```
#### 3- Create the Zone File:
- Copy an existing zone file as a template:
```
sudo cp /etc/bind/db.local /etc/bind/db.mariam
```
- Edit the new file:
```
sudo nano /etc/bind/db.mariam
```
- Modify the content as follows:
```
;
; BIND data file for mariam
;
$TTL    604800
@       IN      SOA     mariam. root.mariam. (
                      2         ; Serial
                  604800         ; Refresh
                   86400         ; Retry
                 2419200         ; Expire
                  604800 )       ; Negative Cache TTL
;
@       IN      NS      mariam.
@       IN      A       192.168.10.1
*       IN      A       192.168.10.1
```
#### 4- Restart BIND9:
```
sudo systemctl restart bind9
```
#### 5- Verify the DNS Configuration: Check the configuration for syntax errors:
```
sudo named-checkconf
sudo named-checkzone mariam /etc/bind/db.mariam
```
### Step 3: Test DNS Resolution
#### 1- Update the DNS Resolver:
- Add your DNS server’s IP address (e.g., 127.0.0.1) to the system's resolver:
```
sudo nano /etc/resolv.conf
```
- Add:
```
nameserver 127.0.0.1
```
#### 2-Test with dig or nslookup:
- Use dig to test the domain:
```
dig mariam
dig mariam
dig mariam.example.com
dig randomsubdomain.mariam
```
#### 3- output:
- For the hosts file, ping mariam will resolve to 192.168.10.1 only for mariam.
- For BIND9, dig mariam and dig *.mariam will resolve to 192.168.10.1.
### Highlight the Differences:
#### - Hosts File:

 - Simpler and local to the system.
 - Limited to explicit entries; no wildcard support.
 - Overrides DNS but requires manual changes on each system.
#### - DNS (BIND9):

 - Centralized management.
 - Supports advanced features like wildcard subdomains and zone files.
 - Scalable for multiple clients.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us.
