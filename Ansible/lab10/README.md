# Lab 10: Organize Ansible playbooks using roles. Create an Ansible role for installing Jenkins, docker, openshift CLI ‘OC’.
## Overview
Ansible roles structure and organize playbooks into reusable components. In this lab, we create an Ansible role to install Jenkins, Docker, and OpenShift CLI (oc). This improves modularity, scalability, and maintainability.
## Prerequisites for Lab 10
### 1- Ansible Setup:
- Install Ansible 2.9+ on the control node.
- Ensure SSH access to target hosts with sudo privileges.
### 2- Target Hosts:
- OS: Ubuntu 20.04/22.04 or CentOS/RHEL 7/8.
- Python 3 installed and accessible.
### 3- Inventory File:
- Define target hosts in an inventory.ini file with correct SSH credentials.
### 4- Dependencies:
- Tools: curl, wget, tar.
- Ensure package managers (apt or yum) are working.
### 5- Network & Firewall:
- Internet access for downloading packages.
- Open necessary ports (e.g., Jenkins on 8080).
### 6- Optional:
- Disk space and prerequisites for OpenShift CLI.
## Step-by-Step Guide
### Step 1 : Create a Project Directory
Organize your playbook and roles:
```
mkdir ansible-roles-lab
cd ansible-roles-lab
ansible-galaxy init jenkins_docker_oc
```
- This creates a directory structure for the jenkins_docker_oc role:
```
jenkins_docker_oc/
├── defaults/
│   └── main.yml
├── files/
├── handlers/
│   └── main.yml
├── meta/
│   └── main.yml
├── tasks/
│   └── main.yml
├── templates/
├── tests/
│   ├── inventory
│   └── test.yml
└── vars/
    └── main.yml
```
## Step 2 : Define the Tasks 
### Edit tasks/main.yml to define the installation steps for Jenkins, Docker, and OpenShift CLI:
```
---
# tasks/main.yml

- name: Install prerequisites
  apt:
    name: "{{ item }}"
    state: present
    update_cache: yes
  loop:
    - apt-transport-https
    - ca-certificates
    - curl
    - software-properties-common

- name: Add Docker GPG key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker repository
  apt_repository:
    repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
    state: present

- name: Install Docker
  apt:
    name: docker-ce
    state: present

- name: Start Docker service
  service:
    name: docker
    state: started
    enabled: true

- name: Add Jenkins GPG key
  apt_key:
    url: https://pkg.jenkins.io/debian/jenkins.io.key
    state: present

- name: Add Jenkins repository
  apt_repository:
    repo: "deb https://pkg.jenkins.io/debian binary/"
    state: present

- name: Install Jenkins
  apt:
    name: jenkins
    state: present

- name: Start Jenkins service
  service:
    name: jenkins
    state: started
    enabled: true

- name: Download OpenShift CLI
  get_url:
    url: https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
    dest: /tmp/openshift-client-linux.tar.gz

- name: Extract OpenShift CLI
  unarchive:
    src: /tmp/openshift-client-linux.tar.gz
    dest: /usr/local/bin
    remote_src: yes
```
## Step 3 : Define Variables 
### Customize installation paths or versions in defaults/main.yml:
```
docker_version: "20.10.8"
jenkins_version: "latest"
oc_url: "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz"
```
## Step 4 : Create a Playbook to Call the Role
### Create install.yml in the root directory:
```
---
- name: Install Jenkins, Docker, and OpenShift CLI
  hosts: all
  become: true
  roles:
    - jenkins_docker_oc
```
## Step 5 : Run the Playbook
### 1- Check the playbook
```
ansible-playbook install.yml --check
```
### 2- Execute the playbook 
```
ansible-playbook install.yml
```
## Expected Output
### During Execution:
```
PLAY [Install Jenkins, Docker, and OpenShift CLI] *******************************

TASK [Gathering Facts] *********************************************************
ok: [host1]

TASK [jenkins_docker_oc : Install prerequisites] *******************************
changed: [host1]

TASK [jenkins_docker_oc : Add Docker GPG key] **********************************
changed: [host1]

TASK [jenkins_docker_oc : Add Docker repository] *******************************
changed: [host1]

TASK [jenkins_docker_oc : Install Docker] **************************************
changed: [host1]

TASK [jenkins_docker_oc : Start Docker service] ********************************
changed: [host1]

TASK [jenkins_docker_oc : Add Jenkins GPG key] *********************************
changed: [host1]

TASK [jenkins_docker_oc : Add Jenkins repository] ******************************
changed: [host1]

TASK [jenkins_docker_oc : Install Jenkins] *************************************
changed: [host1]

TASK [jenkins_docker_oc : Start Jenkins service] *******************************
changed: [host1]

TASK [jenkins_docker_oc : Download OpenShift CLI] ******************************
changed: [host1]

TASK [jenkins_docker_oc : Extract OpenShift CLI] *******************************
changed: [host1]

PLAY RECAP *********************************************************************
host1                      : ok=12   changed=10   unreachable=0    failed=0
```
# Validation
### 1- Check Jenkins status :
```
systemctl status jenkins
```
### 2- Verify Docker installation :
```
docker --version
```
### 3- Check OpenShift CLI (oc) version:
```
oc version
```
# Summary
### - Role: Modular structure organizes the configuration for Jenkins, Docker, and OpenShift CLI.
### - Efficiency: Simplifies task reuse and enhances maintainability.
### - Scalability: Adapts easily for new hosts or components.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
