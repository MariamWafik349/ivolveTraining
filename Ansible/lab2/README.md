# Lab 8: Ansible Playbooks for Web Server Configuration Write an Ansible playbook to automate the configuration of a web server.
## Overview: Automating Web Server Configuration with Ansible Playbooks
In this lab, you will write an Ansible playbook to install and configure a web server on a managed host. The playbook will ensure that the web server is installed, started, and serves a default web page.
## Step-by-Step Guide
### Step 1: Prerequisites
#### 1- Ensure Ansible is installed on the control node.
#### 2- Ensure SSH connectivity between the control node and the managed hosts (refer to previous labs for setting up SSH and inventory files).
#### 3- Update the managed hosts:
```
sudo apt update && sudo apt upgrade -y  # For Ubuntu/Debian
sudo yum update -y                      # For CentOS/RHEL
```
### Step 2: Define Your Inventory
#### 1- Create an inventory file (if not already done):
```
nano ~/ansible/inventory
```
#### 2- Add the managed hosts:
````
[webservers]
54.226.126.195 ansible_user=ubuntu
```
### Step 3: Create the Playbook
#### 1- Navigate to your Ansible directory:
```
cd ~/ansible
```
#### 2- Create a playbook file:
```
nano webserver.yml
```
#### 3- Add the following playbook content:
```
---
- name: Install and configure Apache
  hosts: webservers
  become: yes

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: latest
   
    - name: Edit html file
      copy: 
        dest: /var/www/html/index.html
        content: Hello World
  
    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: true
```
### Step 4: Run the Playbook
#### 1- Execute the playbook:
```
ansible-playbook -i inventory webserver.yml
```
#### 2- Monitor the output for any errors.
### Step 5: Verify the Web Server
#### 1- On the managed host, check if the web server is running:
```
systemctl status apache2   # For Debian/Ubuntu
systemctl status httpd     # For CentOS/RHEL
```
#### 2- Open a web browser and navigate to the IP address of the managed host:
```
http://54.226.126.195
```
You should see the message:
```
Welcome to Ansible Automated Web Server!
```
# Outcome
- The web server is installed, configured, and started on the managed host.
- The default web page (index.html) is deployed.
- HTTP traffic is allowed through the firewall, and the server is accessible over the network.
This playbook provides a reusable automation script for setting up web servers across multiple hosts.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us







