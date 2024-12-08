# Lab 9: Write an Ansible playbook to install MySQL, create ivovle database, create user with all privileges on ivolve DB. Use Ansible Vault to encrypt sensitive information such as database user password, and incorporate the encrypted data into an Ansible playbook.
## Overview
### This lab focuses on using Ansible to:
1- Install MySQL.
2- Create a database (ivolve).
3- Create a user with all privileges on the database.
4- Secure sensitive information (e.g., passwords) using Ansible Vault.
5- This ensures secure automation of database setup with reusable configurations.
## Step-by-Step Guide
### Step 1 : Prepare the Environment
#### 1- Install Ansible Vault (included with Ansible by default).
#### 2- Set Up Inventory File:
```
[dbservers]
dbserver1 ansible_host=192.168.1.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```
### Step 2 : Create the Vault-Encrypted File
#### 1- Create a Vault File for Sensitive Data :
```
ansible-vault create secrets.yml
```
#### 2- Add Encrypted Variables: 
```
db_root_password: "secure_root_password"
db_user: "ivolve_user"
db_user_password: "secure_user_password"
```
#### 3- Save and Encrypt the File. 
- Ansible Vault will encrypt secrets.yml.
### Step 3 :  Write the Ansible Playbook
#### 1- Create a YAML Playbook File (mysql_setup.yml):
```
---
- name: MySQL Setup and Database Configuration
  hosts: dbservers
  become: true
  vars_files:
    - secrets.yml  # Include the encrypted file
  tasks:
    - name: Install MySQL
      apt:
        name: mysql-server
        state: present

    - name: Ensure MySQL is running
      service:
        name: mysql
        state: started
        enabled: true

    - name: Set MySQL root password
      mysql_user:
        name: root
        host: localhost
        password: "{{ db_root_password }}"
        login_unix_socket: /var/run/mysqld/mysqld.sock

    - name: Create the ivolve database
      mysql_db:
        name: ivolve
        state: present
        login_user: root
        login_password: "{{ db_root_password }}"

    - name: Create a new MySQL user
      mysql_user:
        name: "{{ db_user }}"
        password: "{{ db_user_password }}"
        priv: "ivolve.*:ALL"
        host: "%"
        state: present
        login_user: root
        login_password: "{{ db_root_password }}"
```
### Step 4 : Test the Playbook
#### 1- Run the playbook in check mode :
```
ansible-playbook mysql_setup.yml --check --ask-vault-pass
```
#### 2- Provide the Vault password when prompted.
### Step 5 : Execute the Playbook
#### Run the playbook to apply the changes:
```
ansible-playbook mysql_setup.yml --ask-vault-pass
```
### Step 6 :  Validate the Configuration
#### 1- Log in to the MySQL database on the target server
```
mysql -u ivolve_user -p
```
#### 2- Verify the ivolve database exists and user permissions are applied.
### Step 7 : Maintain Security
- Use ansible-vault edit secrets.yml to update encrypted data.
- Always avoid hardcoding sensitive data in playbooks.
## Expected Output:
### Command 1 : Check the Playbook
```
ansible-playbook mysql_setup.yml --check --ask-vault-pass
```
### Sample Output:
```
Vault password: ********
PLAY [MySQL Setup and Database Configuration] **********************************

TASK [Gathering Facts] *********************************************************
ok: [dbserver1]

TASK [Install MySQL] ***********************************************************
ok: [dbserver1] => {"changed": false, "msg": "package already installed"}

TASK [Ensure MySQL is running] *************************************************
ok: [dbserver1] => {"changed": false, "status": "started"}

TASK [Set MySQL root password] *************************************************
(skipped: --check mode)

TASK [Create the ivolve database] **********************************************
(skipped: --check mode)

TASK [Create a new MySQL user] *************************************************
(skipped: --check mode)

PLAY RECAP *********************************************************************
dbserver1                 : ok=3    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```
### Command 2: Execute the Playbook
```
ansible-playbook mysql_setup.yml --ask-vault-pass
```
### Sample Output:
```
Vault password: ********
PLAY [MySQL Setup and Database Configuration] **********************************

TASK [Gathering Facts] *********************************************************
ok: [dbserver1]

TASK [Install MySQL] ***********************************************************
ok: [dbserver1] => {"changed": false, "msg": "package already installed"}

TASK [Ensure MySQL is running] *************************************************
ok: [dbserver1] => {"changed": false, "status": "started"}

TASK [Set MySQL root password] *************************************************
changed: [dbserver1] => {"changed": true, "msg": "Password updated"}

TASK [Create the ivolve database] **********************************************
changed: [dbserver1] => {"changed": true, "db": "ivolve"}

TASK [Create a new MySQL user] *************************************************
changed: [dbserver1] => {"changed": true, "user": "ivolve_user"}

PLAY RECAP *********************************************************************
dbserver1                 : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Here’s what the expected output will look like when you execute the Ansible playbook for this lab:

Command 1: Check the Playbook
bash
Copy code
ansible-playbook mysql_setup.yml --check --ask-vault-pass
Sample Output:

plaintext
Copy code
Vault password: ********
PLAY [MySQL Setup and Database Configuration] **********************************

TASK [Gathering Facts] *********************************************************
ok: [dbserver1]

TASK [Install MySQL] ***********************************************************
ok: [dbserver1] => {"changed": false, "msg": "package already installed"}

TASK [Ensure MySQL is running] *************************************************
ok: [dbserver1] => {"changed": false, "status": "started"}

TASK [Set MySQL root password] *************************************************
(skipped: --check mode)

TASK [Create the ivolve database] **********************************************
(skipped: --check mode)

TASK [Create a new MySQL user] *************************************************
(skipped: --check mode)

PLAY RECAP *********************************************************************
dbserver1                 : ok=3    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
Explanation:

The --check flag simulates the execution without making changes.
Tasks are skipped because no actual changes are applied in check mode.
Command 2: Execute the Playbook
bash
Copy code
ansible-playbook mysql_setup.yml --ask-vault-pass
Sample Output:

plaintext
Copy code
Vault password: ********
PLAY [MySQL Setup and Database Configuration] **********************************

TASK [Gathering Facts] *********************************************************
ok: [dbserver1]

TASK [Install MySQL] ***********************************************************
ok: [dbserver1] => {"changed": false, "msg": "package already installed"}

TASK [Ensure MySQL is running] *************************************************
ok: [dbserver1] => {"changed": false, "status": "started"}

TASK [Set MySQL root password] *************************************************
changed: [dbserver1] => {"changed": true, "msg": "Password updated"}

TASK [Create the ivolve database] **********************************************
changed: [dbserver1] => {"changed": true, "db": "ivolve"}

TASK [Create a new MySQL user] *************************************************
changed: [dbserver1] => {"changed": true, "user": "ivolve_user"}

PLAY RECAP *********************************************************************
dbserver1                 : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
### Verification Steps
### 1- Check MySQL Installation:
```
mysql --version
```
### Output: 
- mysql Ver 8.0.34-0ubuntu0.22.04.1 for Linux on x86_64 (Ubuntu)
### 2- Verify Database and User: Log in to the MySQL server:
```
mysql -u ivolve_user -p
```
- Enter the user password
### Run: 
```
SHOW DATABASES;
```
### Output:
```
+--------------------+
| Database           |
+--------------------+
| ivolve             |
| information_schema |
+--------------------+
```
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us

