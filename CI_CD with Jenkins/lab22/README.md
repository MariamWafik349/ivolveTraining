# Lab 22: Jenkins Installation
 - Objective: Install Jenkins
 - OPTION 1: Install and configure Jenkins as a service
 - OPTION 2: Install and Configure Jenkins as a container.
## Overview:
Jenkins is an open-source automation server used to automate tasks related to building, testing, and deploying applications. It integrates with numerous tools and is highly extensible.

 - Option 1: Jenkins as a Service: This method involves installing Jenkins directly on the host machine and running it as a background service.
 - Option 2: Jenkins as a Container: This method involves running Jenkins in a Docker container, which provides more flexibility and scalability in managing Jenkins instances.
## Prerequisites:
1- For Option 1: Jenkins as a Service
 - A Linux-based system (Ubuntu, CentOS, or similar).
 - Java installed (Jenkins requires Java to run).
 - Root or sudo privileges to install packages and services.
2- For Option 2: Jenkins as a Container
 - Docker installed on your system.
 - Basic knowledge of Docker commands.
 - Network connectivity for downloading the Jenkins Docker image.
## Step by step :
 - Here’s a similar step-by-step process for installing Jenkins and setting it up to work with Minikube and Kubernetes in your environment:
### Task 1: Install Jenkins
 - Objective: Install Jenkins, configure it as a service, and ensure it's ready for integration with Kubernetes.
#### Step 1: Update Package Index and Install Java
```
# Update package index
sudo apt update

# Install OpenJDK 17
sudo apt install openjdk-17-jdk -y

# Verify Java installation
java -version
```
#### Step 2: Add Jenkins Repository Key and Repository
```
# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository to sources.list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index again
sudo apt update
```
#### Step 3: Install Jenkins
```
# Install Jenkins
sudo apt install jenkins -y
```
#### Step 4: Start Jenkins Service and Enable it to Start on Boot
```
# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins
```
#### Step 5: Allow Port 8080 Through Firewall
```
# Allow port 8080 through the firewall (Jenkins default port)
sudo ufw allow 8080
```
### Task 2: Install Minikube and Set Up Kubernetes Cluster
 - Objective: Install Minikube and set up a Kubernetes cluster to use for Jenkins deployments.
#### Step 1: Install kubectl (Kubernetes CLI)
```
# Install kubectl (Kubernetes CLI)
sudo snap install kubectl --classic
```
#### Step 2: Download and Install Minikube
```
# Download the latest version of Minikube
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -O minikube

# Make the file executable
chmod 755 minikube

# Move the file to the /usr/local/bin/ directory
sudo mv minikube /usr/local/bin/

# Verify the installation
minikube version
```
#### Step 3: Start Minikube
```
# Start Minikube with 4GB memory, 2 CPUs, Docker driver, and Flannel CNI
minikube start --memory=4096 --cpus=2 --driver=docker --flannel=cni

# Check Minikube status
minikube status
```
### Task 3: Allow Jenkins to Access the Minikube Cluster
 - Objective: Create a service account and necessary roles to allow Jenkins to interact with the Kubernetes cluster.
#### Step 1: Create a Kubernetes Service Account for Jenkins
```
# Create a service account for Jenkins in the Kubernetes cluster
kubectl create serviceaccount jenkins

# Bind the service account to the cluster-admin role
kubectl create clusterrolebinding jenkins-admin --clusterrole=admin --serviceaccount=default:jenkins
```
#### Step 2: Generate and Retrieve Jenkins Token
```
# Create a secret for Jenkins token
kubectl create secret generic jenkins-token --from-literal=token=$(kubectl create token jenkins) --namespace=default

# Retrieve the token and decode it
kubectl get secret jenkins-token -o jsonpath='{.data.token}' | base64 --decode
Copy the token and add it as a credential in Jenkins.
```
### Task 4: Use Kubernetes Config File with Jenkins User
 - Objective: Allow Jenkins to access the Kubernetes cluster using the Kubernetes config file.
#### Step 1: Log in as Jenkins User
```
# Log in as the Jenkins user
sudo -i -u jenkins
```
#### Step 2: Verify Kubernetes Config File Exists
```
# Verify if the Kubernetes config file exists for the Jenkins user
ls -l ~/.kube/config
```
#### Step 3: Grant Permissions to Jenkins User to Access Kubernetes Cluster
```
# Grant read/write permissions for the Kubernetes config file to Jenkins user
sudo chmod 600 ~jenkins/.kube/config
```
### Task 5: Jenkins Pipeline Integration with Kubernetes (Minikube)
 - Objective: Set up a Jenkins pipeline to deploy applications to Minikube using Kubernetes.
#### Step 1: Create a Deployment Stage in Jenkins Pipeline
```
stage('Deploy to Minikube') {
    steps {
        script {
            sh '''
            export KUBECONFIG=~/.kube/config

            # Apply the deployment file
            kubectl apply -f ${DEPLOYMENT_FILE}

            # Validate the deployment
            kubectl rollout status deployment/${IMAGE_NAME} --timeout=60s
            '''
        }
    }
}
Replace ${DEPLOYMENT_FILE} with the path to your Kubernetes deployment YAML file and ${IMAGE_NAME} with the name of your deployment (Docker image).
```
### Task 6: Test Pipeline Access
 - Objective: Verify that the Jenkins user can access the Minikube cluster and interact with the nodes.
#### Step 1: Log in as Jenkins User
```
# Log in as the Jenkins user
sudo -i -u jenkins
```
#### Step 2: Export the Kubernetes Config Path and Check Cluster Access
```
# Set the KUBECONFIG environment variable
export KUBECONFIG=~/.kube/config

# Verify if Jenkins can access the Kubernetes cluster
kubectl get nodes
```
### Outputs :
1- Successfully install Jenkins as a service and configure it.
2- Install Minikube and configure it to use as a local Kubernetes cluster.
3- Allow Jenkins to interact with the Kubernetes cluster by creating a service account and adding credentials.
4- Set up a Jenkins pipeline to deploy applications to Minikube, and test the setup by verifying access to Kubernetes.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
