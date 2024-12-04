# Lab 6: Generate public and private keys and enable SSH from your machine to another VM using the key. Configure SSH to just run ‘ssh ivolve’ (amazonlinux) without specify username, IP and key in the command.
## Overview: SSH Key Authentication with Alias Configuration
This lab demonstrates how to set up SSH key-based authentication between your machine and another VM, eliminating the need to specify the username, IP address, and key manually. You will configure an SSH alias named ivolve for easy access.
## Step-by-Step Guide
### Step 1: Generate SSH Keys
#### 1- Open a terminal on your local machine.
#### 2- Generate an SSH key pair:
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/ivolve_key
```
#### 3- Confirm the key files:
- Private key: ~/.ssh/ivolve_key
- Public key: ~/.ssh/ivolve_key.pub
### Step 2: Copy the Public Key to the VM
#### 1- Use the ssh-copy-id command to copy the public key to the remote VM:
```
ssh-copy-id -i ~/.ssh/ivolve_key.pub username@VM_IP
```
- Replace username with the VM’s username (e.g., ec2-user for Amazon Linux).
- Replace VM_IP with the actual IP address of the VM.
#### 2- Verify that key-based authentication works:
```
ssh -i ~/.ssh/ivolve_key username@VM_IP
```
### Step 3: Configure the SSH Alias
#### 1- Open the SSH configuration file:
```
nano ~/.ssh/config
```
#### 2- Add the following configuration:
```
Host ivolve
    HostName VM_IP
    User username
    IdentityFile ~/.ssh/ivolve_key
```
- Replace VM_IP with the VM’s IP address.
- Replace username with the appropriate username.
#### 3- Save and exit the file.
### Step 4:  Set Proper Permissions:
###  Set correct permissions for SSH directory and files
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```
### Step 5:Test the SSH Alias
#### 1- Test the alias by running:
```
ssh ivolve
```
#### 2- You should be able to log in without specifying the username, IP address, or key.
# Outcome
- SSH key-based authentication is enabled between your local machine and the VM.
- You can log in using ssh ivolve without specifying a username, IP address, or key manually.
- The configuration enhances security and convenience.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us

