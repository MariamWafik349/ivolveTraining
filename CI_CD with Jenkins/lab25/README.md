# Lab 25: Role-based Authorization 
Objective: Create user1 and user2.
Assign admin role for user1 & read-only role for user2.
## Overview:
- In this lab, you will implement Role-based Authorization (RBA) in Jenkins to control access levels for different users. Jenkins provides flexible user management and role assignment features through the Role-Based Authorization Strategy Plugin. This allows you to assign different permissions to users or groups of users based on roles, such as admin, read-only, etc.
- By the end of this lab, you'll have two users:
1- user1: Admin role (full access to Jenkins).
2- user2: Read-only role (limited access to Jenkins).
## Prerequisites:
1- Jenkins installation: You need to have Jenkins installed and running on your system.
2- Role-Based Authorization Strategy Plugin: Ensure that the Role-based Authorization Strategy Plugin is installed in Jenkins.
3- Administrator access: You need to have administrator access in Jenkins to configure security settings and create users.
## Steps to Achieve the Objective:
### Step 1: Install the Role-Based Authorization Strategy Plugin
#### Step 1.1: Install the Plugin
1- Log in to Jenkins as an administrator.
2- Go to Manage Jenkins > Manage Plugins.
3- In the Available tab, search for Role-based Authorization Strategy.
4- Check the box next to Role-based Authorization Strategy and click Install without restart.
#### Step 1.2: Restart Jenkins (if needed)
- Some plugins may require a Jenkins restart to take effect. If prompted, restart Jenkins.
### Step 2: Enable Role-Based Authorization Strategy
#### Step 2.1: Enable Authorization Strategy
1- Go to Manage Jenkins > Configure Global Security.
2- Under the Security Realm section, select the appropriate Security Realm for authentication (e.g., Jenkins’ own user database or LDAP).
3- In the Authorization section, select Role-Based Strategy.
4- Save your changes.
### Step 3: Create Roles for User1 and User2
#### Step 3.1: Configure Roles
1- Go to Manage Jenkins > Manage and Assign Roles > Manage Roles.
2- You will see two sections: Global roles and Project roles.
### Step 3.2: Create Admin Role for user1
1- In the Global roles section, under Role, enter admin (or another role name of your choice).
2- Under Permissions, check the boxes for permissions you want to assign to the admin role. Typically, you would check the following:
  - Overall/Administer
  - Overall/Read
  - Job/Build
  - Job/Configure
  - Job/Discover
  - View/Read
These permissions give full access to Jenkins, allowing the user to perform all administrative tasks.
3- Click Save.
#### Step 3.3: Create Read-Only Role for user2
1- In the Global roles section, create a new role called readonly (or another name of your choice).
2- Under Permissions, only check the following:
3- Overall/Read
  - Job/Read
  - This will give read-only access to the Jenkins instance, allowing the user to view jobs and configurations but not make any changes.
  - Click Save.
### Step 4: Create Users and Assign Roles
#### Step 4.1: Create user1 and user2
1- Go to Manage Jenkins > Manage Users.
2- Click on Create User.
3- For user1:
 - Enter username: user1
 - Enter password: (choose a secure password)
 - Fill in the rest of the details and click Create User.
4- Repeat for user2:
 - Enter username: user2
 - Enter password: (choose a secure password)
 - Fill in the rest of the details and click Create User.
#### Step 4.2: Assign Roles to Users
1- Go to Manage Jenkins > Manage and Assign Roles > Assign Roles.
2- In the Assign Roles section, assign the following roles to users:
 - user1: Assign the admin role.
  -user2: Assign the readonly role.
3- Click Save to apply the changes.
### Step 5: Verify the Role Assignments
#### Step 5.1: Test user1 (Admin Role)
1- Log out from Jenkins and log in as user1.
2- Verify that user1 has full administrative access by checking the following:
  - Access to Manage Jenkins and other administrative settings.
  - Ability to configure jobs and views.
- Expected Output:
  - user1 should have full control over the Jenkins instance.
#### Step 5.2: Test user2 (Read-Only Role)
1- Log out and log in as user2.
2- Verify that user2 has read-only access by checking the following:
 - user2 should only be able to view jobs and configurations.
 - user2 should not be able to configure, build, or delete jobs.
- Excpected Output:
 - user2 should only see options to view Jenkins jobs and configurations, but not make changes.
### Expected Output:
  - user1: Full administrative access (create, configure, and delete jobs, manage Jenkins settings).
  - user2: Read-only access (view jobs, see configurations, but cannot perform administrative tasks like creating or modifying jobs).
## Conclusion:
You have successfully configured Role-based Authorization in Jenkins by:
1- Installing the necessary plugin.
2- Creating user roles (admin and read-only).
3- Assigning the appropriate roles to user1 and user2.
4- Verifying that the role assignments work as expected
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
