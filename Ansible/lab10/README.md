# Lab 8: Ansible Playbooks for Web Server Configuration Write an Ansible playbook to automate the configuration of a web server.
## Overview: Ansible Playbook for Web Server Configuration
An Ansible playbook automates the setup of a web server, ensuring consistency, efficiency, and scalability across multiple systems.
### Steps in the Playbook
1- Define Inventory: List target servers and connection details.
2- Update System: Update and upgrade system packages (apt).
3- Install Web Server: Install Apache or Nginx.
4- Enable Service: Start the web server and enable it on boot (service).
5- Deploy Content: Copy index.html to /var/www/html using the copy module.
6- Open Firewall Port: Allow HTTP traffic on port 80 (ufw).
## Step 1: Prepare the Environment
### 1- Install Ansible on your control node if not already installed:
```
sudo apt update && sudo apt install ansible -y
```
### 2- Set Up Inventory File: Create an inventory file (hosts) to define the target servers:
```
[webservers]
server1 ansible_host=192.168.1.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
server2 ansible_host=192.168.1.11 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```
## Step 2: Define the Playbook
### 1- Create a YAML File: Create a playbook file (web_server.yml)
### 2- Write the Playbook:
```
---
- name: Configure Web Server
  hosts: webservers
  become: true  # Elevates privileges to root for necessary tasks
  tasks:
    - name: Update and upgrade system packages
      apt:
        update_cache: yes
        upgrade: dist
    
    - name: Install Apache (or Nginx)
      apt:
        name: apache2
        state: present

    - name: Ensure Apache is started and enabled
      service:
        name: apache2
        state: started
        enabled: true

    - name: Deploy custom index.html
      copy:
        src: /path/to/index.html
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'

    - name: Open HTTP port in the firewall
      ufw:
        rule: allow
        port: 80
        proto: tcp
```
## Step 3: Prepare the Files
### 1- Create the index.html file with your desired content:
```
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Web Server</title>
</head>
<body>
    <h1>It works!</h1>
</body>
</html>
```
### 2- Save this file
## Step 4: Test the Playbook
### 1- Run the playbook in check mode to simulate changes
```
ansible-playbook web_server.yml --check
```
## Step 5: Execute the Playbook
### Run the playbook to apply the configuration:
```
ansible-playbook web_server.yml
```
### Step 6: Verify Configuration
1- Access the web server via a browser using its IP address
2- Confirm the index.html file is displayed.
# 🙏 Thank You


