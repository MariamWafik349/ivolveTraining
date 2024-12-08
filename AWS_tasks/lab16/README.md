# lab 16 : Build a serverless application using AWS Lambda, API Gateway, and DynamoDB.
## Overview
In this tutorial, you will build a serverless application that uses AWS Lambda to execute code, API Gateway to expose the application as a REST API, and DynamoDB as a database to store data. The application will handle basic CRUD (Create, Read, Update, Delete) operations for items in the DynamoDB table.
## Prerequisites
1- AWS Account with sufficient permissions to manage Lambda, API Gateway, and DynamoDB.
2- AWS CLI installed and configured.
3- Node.js and npm installed for Lambda function development.
4- IAM Role with policies for Lambda execution and DynamoDB access.
5- Text Editor/IDE for coding.
6- Postman or cURL to test the API Gateway endpoints.
## Step-by-Step Guide
### Step 1: Create a DynamoDB Table
#### 1- Create Table using AWS CLI:
```
aws dynamodb create-table \
  --table-name ItemsTable \
  --attribute-definitions AttributeName=ItemId,AttributeType=S \
  --key-schema AttributeName=ItemId,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```
#### 2- Verify Table Creation:
```
aws dynamodb list-tables
```
### Step 2: Write the Lambda Function
#### 1- Create a directory for the project:
```
mkdir lambda-app && cd lambda-app
```
#### 2- Initialize a Node.js project:
```
npm init -y
```
#### 3- Install AWS SDK:
```
npm install aws-sdk
```
#### 4- Write the Lambda Code (index.js):
```
const AWS = require('aws-sdk');
const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    const { httpMethod, body, pathParameters } = event;

    switch (httpMethod) {
        case 'POST': // Create Item
            const item = JSON.parse(body);
            await dynamo.put({ TableName: 'ItemsTable', Item: item }).promise();
            return { statusCode: 201, body: JSON.stringify({ message: 'Item created!' }) };

        case 'GET': // Read Item
            const itemId = pathParameters?.id;
            const result = await dynamo.get({ TableName: 'ItemsTable', Key: { ItemId: itemId } }).promise();
            return { statusCode: 200, body: JSON.stringify(result.Item) };

        case 'PUT': // Update Item
            const updateData = JSON.parse(body);
            await dynamo.update({
                TableName: 'ItemsTable',
                Key: { ItemId: updateData.ItemId },
                UpdateExpression: 'set #name = :name',
                ExpressionAttributeNames: { '#name': 'Name' },
                ExpressionAttributeValues: { ':name': updateData.Name }
            }).promise();
            return { statusCode: 200, body: JSON.stringify({ message: 'Item updated!' }) };

        case 'DELETE': // Delete Item
            const deleteId = pathParameters?.id;
            await dynamo.delete({ TableName: 'ItemsTable', Key: { ItemId: deleteId } }).promise();
            return { statusCode: 200, body: JSON.stringify({ message: 'Item deleted!' }) };

        default:
            return { statusCode: 400, body: 'Unsupported method' };
    }
};
```
#### 5- Zip the Lambda Function:
```
zip function.zip index.js node_modules
```
### Step 3: Deploy the Lambda Function
#### 1- Create an IAM Role for Lambda:
- Attach AWSLambdaBasicExecutionRole and AmazonDynamoDBFullAccess policies.
#### 2- Deploy the Lambda Function:
```
aws lambda create-function \
  --function-name ItemsFunction \
  --runtime nodejs18.x \
  --role arn:aws:iam::<Account-ID>:role/<IAM-Role-Name> \
  --handler index.handler \
  --zip-file fileb://function.zip
```
#### 3- Test the Lambda Function Locally:
```
aws lambda invoke --function-name ItemsFunction output.json
cat output.json
```
### Step 4: Create an API Gateway
#### 1- Create a REST API:
```
aws apigateway create-rest-api --name "ItemsAPI"
```
#### 2- Get API Resource ID:
```
aws apigateway get-resources --rest-api-id <API-ID>
```
#### 3- Create Resources and Methods:
```
# Add a resource
aws apigateway create-resource \
  --rest-api-id <API-ID> \
  --parent-id <Parent-Resource-ID> \
  --path-part items

# Add HTTP methods
aws apigateway put-method \
  --rest-api-id <API-ID> \
  --resource-id <Resource-ID> \
  --http-method POST \
  --authorization-type "NONE"
```
#### 4- Link API Gateway to Lambda:
```
aws apigateway put-integration \
  --rest-api-id <API-ID> \
  --resource-id <Resource-ID> \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri "arn:aws:apigateway:<region>:lambda:path/2015-03-31/functions/arn:aws:lambda:<region>:<Account-ID>:function:ItemsFunction/invocations"
```
#### 5- Deploy the API:
```
aws apigateway create-deployment --rest-api-id <API-ID> --stage-name dev
```
### Step 5: Test the Application
#### 1- Get the API Endpoint:
```
echo "https://<API-ID>.execute-api.<region>.amazonaws.com/dev/items"
```
#### 2- Test CRUD Operations using cURL or Postman:
#####- POST: Add a new item.
```
curl -X POST -H "Content-Type: application/json" \
-d '{"ItemId":"1","Name":"TestItem"}' \
https://<API-ID>.execute-api.<region>.amazonaws.com/dev/items
```
##### - GET: Retrieve an item.
```
curl -X GET https://<API-ID>.execute-api.<region>.amazonaws.com/dev/items/1
```
##### - PUT: Update an item.
```
curl -X PUT -H "Content-Type: application/json" \
-d '{"ItemId":"1","Name":"UpdatedItem"}' \
https://<API-ID>.execute-api.<region>.amazonaws.com/dev/items
```
##### - DELETE: Delete an item.
```
curl -X DELETE https://<API-ID>.execute-api.<region>.amazonaws.com/dev/items/1
```
### Expected Output
1- DynamoDB Table: A table named ItemsTable exists.
2- Lambda Function: Executes CRUD operations on the table.
3- API Gateway: Endpoints return correct responses for each CRUD operation:
    ---POST: { "message": "Item created!" }
    ---GET: { "ItemId": "1", "Name": "TestItem" }
    ---PUT: { "message": "Item updated!" }
    ---DELETE: { "message": "Item deleted!" }
4- Integration: Successfully tested with cURL/Postman.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
