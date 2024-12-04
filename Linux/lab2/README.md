# Lab 2: Schedule a script to run daily at 5:00 PM that automates checking disk space usage for the root file system and sends an email(using msm-tp, mailutils) alert if usage exceeds a specified threshold (10%)
## Overview: Automating Disk Space Monitoring and Alerts
This setup involves creating a script to check disk space usage for the root file system (/) and send an email alert if usage exceeds a specified threshold (e.g., 10%). The script is scheduled to run daily at 5:00 PM using cron. Here's a concise breakdown:
## Steps 
### Step 1: Install Required Utilities
#### 1- Install msmtp and mailutils (for sending emails):
```
sudo apt update
sudo apt install msmtp mailutils -y
```
#### 2- Configure msmtp:
- Edit the configuration file:
```
sudo vim /etc/msmtprc
```
- Add the following configuration (replace placeholders with your email account details):
```
account default
host smtp.example.com  # Replace with your SMTP server (e.g., smtp.gmail.com)
port 587
auth on
user your-email@example.com
password your-email-password
from your-email@example.com
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
```
Replace your-email@gmail.com and your-app-password with your Gmail credentials (App Password) or best practice use (Two Factor Authentication using Google Authenticator)
- Save and exit.
- Set the correct permissions:
```
sudo chmod 600 /etc/msmtprc
```
- Test the email setup:
```
echo "Test email from msmtp" | mail -s "Test Email" recipient-email@example.com
```
Replace recipient-email@example.com with your email address. Confirm you receive the email.
### Step 2: Write the Disk Space Check Script
#### 1- Create a script file:
```
nano check_disk_space.sh
```
#### 2- Add the following script:
```
#!/bin/bash

# Define threshold (in percentage)
THRESHOLD=10

# Get the disk usage of the root file system
USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

# Check if usage exceeds the threshold
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    # Send email alert
    echo "Disk space usage is critically high: ${USAGE}%" | mail -s "Disk Space Alert" recipient-email@example.com
fi
```
#### 3- Replace recipient-email@example.com with your email address.
#### 4- Save and exit the editor.
#### 5- Make the script executable:
```
chmod +x check_disk_space.sh
```
### Step 3: Schedule the Script to Run Daily at 5:00 PM
#### 1- Open the crontab editor:
```
crontab -e
```
#### 2- Add the following line to schedule the script:
```
0 17 * * * /path/to/check_disk_space.sh
```
Replace /path/to/check_disk_space.sh with the full path to your script file
#### 3- Save and exit the crontab editor.
### Step 4: Verify the Setup
#### 1- Test the Script Manually: Run the script to ensure it works as expected:
```
./check_disk_space.sh
```
#### 2- Verify the Cron Job: Check if the cron job is listed correctly:
```
crontab -l
```
#### 3- Check Logs: After 5:00 PM, verify if the cron job executed:
```
grep CRON /var/log/syslog
```
### Step 5: Monitor the Email Alert
1- Ensure that the email alert is sent if the disk space usage exceeds the defined threshold (10% in this example).
2- If you don’t receive the email, check for issues in the script, msmtp configuration, or cron job logs.
# 🙏 Thank You 
Thank you for using this script. Your feedback and support mean a lot to us

