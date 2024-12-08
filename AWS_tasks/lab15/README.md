# lab 15 : Use the AWS CLI to Create an S3 bucket, configure permissions, and upload/download files to/from the bucket. Enable versioning and logging for the bucket.
## Overview
### This guide demonstrates how to use the AWS CLI to manage an S3 bucket. You will:
1- Create an S3 bucket.
2- Configure bucket permissions.
3- Upload and download files.
4- Enable versioning.
5- Enable logging for the bucket.
## Prerequisites
1- AWS Account: Ensure you have an active AWS account.
2- AWS CLI Installed and Configured:
- Install the AWS CLI (instructions here).
- Configure with aws configure using your access key, secret key, region, and output format.
3- IAM Permissions: Ensure your user has the following permissions:
- s3:CreateBucket
- s3:PutBucketPolicy
- s3:PutObject
- s3:GetObject
- s3:PutBucketVersioning
- s3:PutBucketLogging
4- Files to Test: Prepare test files for upload (e.g., test-file.txt).
### Step 1: Create S3 Bucket
#### Command:
```
aws s3api create-bucket --bucket my-new-s3-bucket-234 --region us-west-2
```
#### Verify Bucket Creation:
##### 1- Using AWS CLI:
```
aws s3 ls
```
You should see your bucket name my-new-s3-bucket-234 listed.
##### 2- From AWS Console:
- Navigate to the S3 Service in the AWS Management Console.
- Check if the bucket my-new-s3-bucket-234 is listed.
### Step 2: Configure Policy
#### Create Policy File:
##### 1- Create and edit the policy.json file:
```
vim policy.json
```
##### 2- Add the following content to policy.json:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:user/my-user-123"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-new-s3-bucket-234/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:user/my-user-123"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-new-s3-bucket-234/*"
    }
  ]
}
```
##### 3- Apply the Policy:
```
aws s3api put-bucket-policy --bucket my-new-s3-bucket-234 --policy file://policy.json
```
##### 4- Verify the Policy:
```
aws s3api get-bucket-policy --bucket my-new-s3-bucket-234
```
### Step 3: Upload an Object
#### 1- Command to Upload:
```
echo "Hello, this is a test file!" | aws s3 cp - s3://my-new-s3-bucket-234/test-file.txt
```
#### 2- Verify Upload:
```
aws s3 ls s3://my-new-s3-bucket-234
```
You should see test-file.txt listed.
### Step 4: Enable Versioning
#### 1- Command to Enable Versioning:
```
aws s3api put-bucket-versioning --bucket my-new-s3-bucket-234 --versioning-configuration Status=Enabled
```
#### 2- Verify Versioning Status:
```
aws s3api get-bucket-versioning --bucket my-new-s3-bucket-234
```
Expected output should show Status: Enabled.
### Step 5: Enable Logging
#### Create Logging Policy:
##### 1- Update policy.json to allow logging:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLogging",
      "Effect": "Allow",
      "Principal": {
        "Service": "logging.s3.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-new-s3-logs-234/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
```
##### 2- Create a target bucket for logs:
```
aws s3api create-bucket --bucket my-new-s3-logs-234 --region us-west-2
```
##### 3- Apply the policy to the target bucket:
```
aws s3api put-bucket-policy --bucket my-new-s3-logs-234 --policy file://policy.json
```
### Enable Logging:
#### 1-Create a logging.json file:
```
{
  "LoggingEnabled": {
    "TargetBucket": "my-new-s3-logs-234",
    "TargetPrefix": "logs/"
  }
}
```
#### 2- Apply logging configuration:
```
aws s3api put-bucket-logging --bucket my-new-s3-bucket-234 --bucket-logging-status file://logging.json
```
### Verify Logging:
- Perform some bucket operations (upload, download).
- Check my-new-s3-logs-234 for logs under the logs/ prefix.
### Expected Output
#### 1- Bucket Creation:
The aws s3 ls command lists my-new-s3-bucket-234.
#### 2- Policy Applied:
Running aws s3api get-bucket-policy displays the applied policy.
#### 3- File Upload:
Running aws s3 ls s3://my-new-s3-bucket-234 lists test-file.txt.
#### 4- Versioning Enabled:
aws s3api get-bucket-versioning shows Status: Enabled.
#### 5- Logging Enabled:
Access logs appear in the my-new-s3-logs-234 bucket under logs/.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us






