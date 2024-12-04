# Lab 1: Configure User and Group for Nginx Installation Without Sudo Password
In this lab, you will:

1-Create a user named MariamWafik.
2-Create a group named ivolve.
3-Add the MariamWafik user to the ivolve group.
4-Configure the MariamWafik user to install and manage Nginx without being prompted for a sudo password
## Steps
### 1. Create the MariamWafik user
```
sudo adduser MariamWafik
```
### 2. 2. Create the ivolve group
```
sudo groupadd ivolve
```
### 3. Add MariamWafik to the ivolve group
```
sudo usermod -aG ivolve MariamWafik
```
### 4. Modify sudoers file to allow passwordless Nginx installation
```
sudo visudo
MariamWafik ALL=NOPASSWD: /usr/bin/apt-get install nginx, /usr/sbin/service nginx *
```
### 5. Install Nginx as test user
```
sudo -i -u MariamWafik
sudo apt-get install nginx
```
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us.
