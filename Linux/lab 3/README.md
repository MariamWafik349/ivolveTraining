# Lab 3: Create a shell script  
## ping every server in the 172.16.17.x subnet (where x is a number between 0 and 255). If the ping succeeds, display the message “Server 172.16.17.x is up and running” If the ping fails, display the message “Server 172.16.17.x is unreachable”.
## Script
```
#!/bin/bash

// Iterate through all possible IP addresses in the 172.16.17.x subnet
for i in {0..255}; do
  // Define the current IP address
  ip="172.16.17.$i"
  
  // Ping the IP address with a timeout of 1 second (adjustable)
  ping -W 1 -c 1 $ip
  
  // Check the exit status of the ping command
  if [ $? -eq 0 ]; then
    echo "Server $ip is up and running"
  else
    echo "Server $ip is unreachable"
  fi
done
```
## Steps to Use the Script:
### 1- Create the Script File: Save the script to a file :
```
vim ping_servers.sh
```
### 2- Make the Script Executable: Run the following to make the script executable:
```
chmod +x ping_servers.sh
```
### 3- Run the Script: Execute the script:
```
./ping_servers.sh
```
## Explanation of the Script:
- for x in {0..255}: Loops through numbers from 0 to 255.
- ping -c 1 -W 1: Sends one ping request to the target IP with a 1-second timeout.
- &> /dev/null: Suppresses the output of the ping command.
- if condition checks the result of the ping command:
- If successful, it prints "Server ... is up and running."
- If unsuccessful, it prints "Server ... is unreachable."
## Output Example:
```
Server 172.16.17.0 is unreachable
Server 172.16.17.1 is up and running
Server 172.16.17.2 is unreachable
...
```
This script will check all IPs in the 172.16.17.x subnet and display their status.

# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us.
#
