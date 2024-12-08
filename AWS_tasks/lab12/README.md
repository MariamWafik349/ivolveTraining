# lab 12 : Create AWS account, set billing alarm, create 2 IAM groups (admin-developer), admin group has admin permissions, developer group only access to ec2, create admin-1 user with console access only and enable MFA & admin-2-prog user with cli access only and list all users and groups using commands, create dev-user with programmatic and console access and try to access EC2 and S3 from dev user.
## Overview
This task involves creating and configuring an AWS account, setting up billing alarms to monitor costs, creating IAM groups with specific permissions, and setting up users with varying access levels. The goal is to understand and implement IAM best practices and test user access to specific AWS services.
## Prerequisites
1- AWS Account: An active AWS account.
2- AWS CLI: Installed and configured on your local machine or control node.
3- IAM Permissions: Ensure the account user has permissions to create and manage IAM users and groups.
4- Multi-Factor Authentication (MFA) Device: Required for enabling MFA for users.
## Step-by-Step Guide
### Step 1: Create an AWS Account
- If you don't have an AWS account, sign up at https://aws.amazon.com/.
- Complete the sign-up process, including providing a valid payment method.
### Step 2: Set Up a Billing Alarm
1- Go to the AWS Management Console > Billing and Cost Management Dashboard.
2- Navigate to Budgets and click Create budget.
3- Choose Cost budget and specify the budget amount.
4- Set the conditions (e.g., alert when 80% of the budget is used).
5- Configure email notifications for alerting when the threshold is reached.
### Step 3: Create IAM Groups
1- Log in to the AWS Management Console with an admin account.
2- Go to IAM > Groups > Create New Group.
3- Create the admin group:
- Name it admin.
- Attach the AdministratorAccess policy.
4- Create the developer group:
- Name it developer.
- Attach the AmazonEC2ReadOnlyAccess policy
### Command for creating groups (CLI):
```
aws iam create-group --group-name admin
aws iam create-group --group-name developer
```
### Step 4: Create IAM Users
#### 1-Create admin-1 user:
- Set console access only.
- Enable MFA
#### Command for creating admin-1:
```
aws iam create-user --user-name admin-1
aws iam add-user-to-group --user-name admin-1 --group-name admin
```
#### 2-Create admin-2-prog user:
- Set programmatic (CLI) access only
#### Command for creating admin-2-prog:
```
aws iam create-user --user-name admin-2-prog
aws iam add-user-to-group --user-name admin-2-prog --group-name admin
```
#### 3- Create dev-user:
- Set both console and programmatic access.
- Attach developer group for limited permissions.
#### Command for creating dev-user:
```
aws iam create-user --user-name dev-user
aws iam add-user-to-group --user-name dev-user --group-name developer
```
#### Step 5: Enable MFA for admin-1
#### - Use the AWS Management Console or CLI to enable MFA for admin-1
```
aws iam enable-mfa-device --user-name admin-1 --serial-number arn:aws:iam::<account-id>:mfa/admin-1 --authentication-code1 <code1> --authentication-code2 <code2>
```
#### Step 6: List All Users and Groups
Command to list all users:
```
aws iam list-users
```
#### Command to list all groups:
```
aws iam list-groups
```
#### Step 7: Test Access for dev-user
1- Log in as dev-user to the AWS Management Console.
2- CLI Test for EC2:
```
aws ec2 describe-instances --profile dev-user
```
Verify that dev-user can only see EC2 instances, not create or modify them.
3- CLI Test for S3:
```
aws s3 ls --profile dev-user
```
Confirm that dev-user can access only the allowed resources based on their permissions.
### Expected Output
- Billing Alarm: An alert notification is configured based on your budget threshold.
- User List Command:
```
{
  "Users": [
    {
      "UserName": "admin-1",
      ...
    },
    {
      "UserName": "admin-2-prog",
      ...
    },
    {
      "UserName": "dev-user",
      ...
    }
  ]
}
```
Group List Command:
```
{
  "Groups": [
    {
      "GroupName": "admin",
      ...
    },
    {
      "GroupName": "developer",
      ...
    }
  ]
}
```
### Access Verification:
- dev-user can see EC2 and S3 but cannot create or modify resources (based on the attached policies).
- admin-1 should have full access and MFA enabled.
- admin-2-prog should have programmatic access and full administrative privileges.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
