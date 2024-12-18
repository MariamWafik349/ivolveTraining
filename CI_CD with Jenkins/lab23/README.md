# Lab 23: Jenkins Pipeline for Application Deployment
## Objective:
 - Automate the process of building a Docker image
 - pushing it to Docker Hub
 -  editing the deployment.yaml file
 -  deploying it to Kubernetes using Jenkins.
## Overview:
 - In this lab, you will create a Jenkins pipeline to automate the following steps:
1- Build a Docker image from a Dockerfile located in a GitHub repository.
2- Push the image to Docker Hub.
3- Edit the deployment.yaml file to update the image version.
4- Deploy the application to a Kubernetes cluster.
5- Add post-actions like notifications or additional tasks after deployment.
## Prerequisites:
1- Jenkins Installation:
 - Jenkins should be installed and running on your machine or on a server.
 - Ensure that the Jenkins server has the necessary plugins installed, including:
   - Docker Pipeline: For interacting with Docker.
   - Kubernetes CLI (kubectl): For deploying to Kubernetes.
   - GitHub plugin: To pull code from GitHub repositories.
2- Docker:
 - Docker should be installed and configured on the machine running Jenkins.
3- Docker Hub Account:
 - You will need a Docker Hub account to push images to.
4- Kubernetes Cluster:
 - A Kubernetes cluster should be set up (e.g., Minikube or a cloud-based Kubernetes cluster) to deploy the application.
5- GitHub Repository:
 - You must have access to the GitHub repository mentioned (e.g., https://github.com/IbrahimAdell/Lab.git), which contains the Dockerfile and deployment.yaml.
## Steps to Achieve the Objective:
### Step 1: Set Up Jenkins Pipeline
#### Step 1.1: Create a New Jenkins Job
1- Log into Jenkins and create a new Pipeline job:
 - Go to Jenkins Dashboard.
 - Click on New Item.
 - Enter a name for the job (e.g., app-deployment-pipeline).
 - Select Pipeline and click OK.
 Step 1.2: Define the Pipeline
1- Under the Pipeline section, in the Pipeline Script area, enter the following script to define your pipeline.
### Step 2: Define Pipeline Stages
#### Step 2.1: Build Docker Image from Dockerfile
- In this stage, we’ll pull the latest code from GitHub, build the Docker image from the Dockerfile, and tag it for Docker Hub.
```
stage('Build Docker Image') {
    steps {
        script {
            // Pull the latest code from the GitHub repository
            git 'https://github.com/IbrahimAdell/Lab.git'

            // Build the Docker image from the Dockerfile in the repository
            def image = docker.build("my-app:${BUILD_NUMBER}")  // Using Jenkins' build number as the tag
        }
    }
}
```
###### Explanation: The git command pulls the repository, and the docker.build command builds the Docker image from the Dockerfile in the repository, tagging it with my-app:${BUILD_NUMBER} (this will ensure a unique version tag for each build).
#### Step 2.2: Push Docker Image to Docker Hub
- In this stage, we’ll log in to Docker Hub and push the image to your Docker Hub repository.
```
stage('Push Docker Image') {
    steps {
        script {
            // Log in to Docker Hub (you can use Jenkins credentials for Docker Hub credentials)
            docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                image.push()
            }
        }
    }
}
```
##### Explanation: The docker.withRegistry command authenticates using the Jenkins credentials (docker-hub-credentials should be configured under Jenkins' Manage Jenkins > Manage Credentials). The image is then pushed to Docker Hub.
#### Step 2.3: Edit deployment.yaml File
- In this stage, we’ll edit the deployment.yaml file to update the image tag for the Kubernetes deployment.
```
stage('Update Deployment YAML') {
    steps {
        script {
            // Read the deployment.yaml file
            def deploymentFile = readFile('deployment.yaml')

            // Replace the image tag in the deployment.yaml file
            def newDeployment = deploymentFile.replaceAll("image: my-app:.*", "image: my-app:${BUILD_NUMBER}")

            // Write the updated file back to the workspace
            writeFile file: 'deployment.yaml', text: newDeployment
        }
    }
}
```
##### Explanation: The readFile command reads the deployment.yaml file, and replaceAll is used to update the image tag with the newly built Docker image's tag. The updated file is then written back.
#### Step 2.4: Deploy to Kubernetes
- This stage will deploy the updated application to your Kubernetes cluster using kubectl.
```
stage('Deploy to Kubernetes') {
    steps {
        script {
            // Set KUBECONFIG to use the correct Kubernetes config
            export KUBECONFIG=~/.kube/config

            // Apply the updated deployment.yaml file to the Kubernetes cluster
            sh 'kubectl apply -f deployment.yaml'

            // Verify that the deployment was successful
            sh 'kubectl rollout status deployment/my-app --timeout=60s'
        }
    }
}
```
##### Explanation: The sh command executes the Kubernetes commands to apply the updated deployment.yaml file and verify the deployment using kubectl rollout status.
#### Step 2.5: Add Post-Action (Optional)
- You can add post-actions, such as notifying a Slack channel or sending an email after the deployment.
```
stage('Post-Deployment Actions') {
    steps {
        script {
            // Example: Send a success notification to Slack (requires Slack plugin)
            slackSend channel: '#deployment-status', message: "Deployment successful: my-app:${BUILD_NUMBER}"
        }
    }
}
```
### Step 3: Trigger Pipeline and Verify
##### Step 3.1: Trigger the Pipeline
- Once you’ve defined the pipeline, save the job and click on Build Now to trigger the pipeline.
#### Step 3.2: Monitor the Build Progress
- You can monitor the progress of each stage in the Build Executor Status or the Console Output to ensure everything is working as expected.
### Expected Output:
1- Build Docker Image: The Docker image should be built from the Dockerfile in the GitHub repository with a unique tag (e.g., my-app:1 for build number 1).
2- Push Docker Image: The image should be successfully pushed to Docker Hub under your Docker Hub account.
3- Update Deployment YAML: The deployment.yaml file will be updated with the new Docker image tag.
4- Deploy to Kubernetes: The Kubernetes deployment should be updated, and the application should be deployed successfully.
5- Post Actions: A post-deployment notification (e.g., to Slack) will be sent, if configured.
### Conclusion:
 - By following the steps above, you’ve created a Jenkins pipeline to:
1- Build and push a Docker image to Docker Hub.
2- Update the Kubernetes deployment.yaml file with the new image tag.
3- Deploy the updated image to your Kubernetes cluster.
4- Perform post-deployment actions like sending notifications.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
