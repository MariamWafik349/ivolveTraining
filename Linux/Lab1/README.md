- highlight task 1 : User and Group Management
Objective: Create a new group named wolve and a new user assigned to this group With a
secure password. Configure the user's permassvons to allow Installing Ng.nx With elevated
privileges using the sudo tool (run sudo command for installing ngjnx Without
1. Create the New Group : 
2. sudo groupadd ivolve
3. Create the New User and Assign to the Group :
4. sudo useradd -m -g ivolve MariamWafik
5. sudo passwd MariamWafik
6. Edit the Sudoers File : 
7. sudo visudo
8. Add a Rule for the User
9. MariamWafik ALL=(ALL) NOPASSWD: /usr/bin/apt-get install nginx
10. su - MariamWafik
11. sudo apt-get install nginx


