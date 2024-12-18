# Lab 24: Jenkins Shared Libraries
Objective: Implement shared libraries in Jenkins to reuse code across multiple pipelines.: Create a shared library for common tasks and demonstrate its usage in different pipelines.
## Overview:
 - In this lab, you will learn how to implement Jenkins Shared Libraries to avoid code duplication and enhance the maintainability of Jenkins pipelines. A shared library allows you to store common code, functions, or steps that can be reused across multiple pipelines, making pipeline maintenance easier.

## Prerequisites:
1- Jenkins Installation:
 - Jenkins should be installed and running.
 - Ensure the Pipeline plugin is installed in Jenkins.
2- GitHub or SCM Repository:
 - A GitHub repository or an SCM (Source Control Management) system to store your shared library.
 - You will need at least one Jenkins pipeline configured to utilize this shared library.
3- Jenkins Credentials:
 - You need to configure the necessary credentials in Jenkins for SCM access to the shared library (e.g., GitHub credentials).
## Steps to Achieve the Objective:
### Step 1: Create the Shared Library Repository
#### Step 1.1: Create a Git Repository for the Shared Library
1- Create a new repository on GitHub or any Git-based SCM (e.g., Bitbucket).
 - Example: jenkins-shared-library
2- Inside the repository, create the necessary directory structure:
```
(root of repository)
├── vars/
│   └── common.groovy    # Groovy file for shared variables
├── src/
│   └── org/
│       └── example/
│           └── Utility.groovy  # Example for reusable functions
└── resources/  # Optional, for configuration files or templates
```
#### Step 1.2: Add Reusable Groovy Code to the Library
 - vars/common.groovy: Define reusable steps or variables that can be called directly within Jenkinsfiles.
```
// common.groovy
def call(String name) {
    echo "Hello, ${name}!"
}
```
 - src/org/example/Utility.groovy: Define utility methods or complex logic in classes that can be imported and used across pipelines.
```
// Utility.groovy
package org.example

class Utility {
    static def printMessage(String message) {
        echo "Utility message: ${message}"
    }
}
```
### Step 2: Configure Jenkins to Access the Shared Library
#### Step 2.1: Configure Global Shared Library in Jenkins
1- Open Jenkins, go to Manage Jenkins > Configure System.
2- Scroll down to the Global Pipeline Libraries section.
3- Click Add to add a new shared library configuration:
 - Name: Give your shared library a name (e.g., jenkins-shared-library).
 - Source Code Management: Choose Git and provide the repository URL (e.g., https://github.com/username/jenkins-shared-library.git).
 - Credentials: If the repository is private, add credentials for Jenkins to access the repository.
 - Branches to Build: You can choose the branch to pull from (e.g., main).
4- Save the configuration.
### Step 3: Use Shared Library in Jenkins Pipeline
#### Step 3.1: Create a Jenkins Pipeline That Uses the Shared Library
1- In Jenkins, create a new Pipeline job or edit an existing one.
2- In the Pipeline script, use the shared library by referencing it with @Library.
Example Jenkinsfile using the shared library:
```
@Library('jenkins-shared-library') _   // Referencing the shared library

pipeline {
    agent any

    stages {
        stage('Greet') {
            steps {
                script {
                    // Calling the function from common.groovy
                    common('World')
                }
            }
        }
        
        stage('Utility Example') {
            steps {
                script {
                    // Calling the static method from Utility.groovy
                    org.example.Utility.printMessage("This is a utility message!")
                }
            }
        }
    }
}
```
#### Explanation: The @Library('jenkins-shared-library') statement imports the shared library. In the Greet stage, the common('World') step is called from the common.groovy file. In the Utility Example stage, we call the printMessage method from the Utility.groovy class.
### Step 4: Test and Verify the Pipeline
#### Step 4.1: Run the Pipeline
1- After setting up the Jenkinsfile to reference the shared library, trigger the pipeline build.
2- Check the Console Output to verify that the shared library code is being executed correctly:
 - You should see output like:
```
Hello, World!
Utility message: This is a utility message!
```
#### Step 4.2: Troubleshoot if Necessary
 - If there are errors, check the following:
   - Ensure the shared library repository is correctly configured in Manage Jenkins.
   - Ensure that the paths to the Groovy files in the shared library are correct.
   - Verify the syntax and structure of the Jenkinsfile.
   - Ensure that the necessary permissions (e.g., GitHub access) are configured for Jenkins.
### Step 5: Reuse the Shared Library in Other Pipelines
 - In other Jenkins pipelines, follow the same steps as above:
   - Reference the shared library using @Library('jenkins-shared-library') _.
   - Use the functions and variables defined in the shared library as needed.
### Expected Output:
1- Pipeline Execution:
 - The pipeline successfully executes the shared library functions from the common.groovy and Utility.groovy files.
2- Console Output:
 - You should see the expected output in the console logs, confirming that the shared library code is correctly executed in your pipeline.
3- Reusability:
 - Once the shared library is set up, you can reuse it in multiple Jenkins pipelines, reducing code duplication and making maintenance easier.
#### Conclusion:
 -  You have successfully created a Jenkins shared library to:
1- Define common tasks and functions.
2- Reference the shared library in multiple Jenkins pipelines.
3- Avoid code duplication and enhance the maintainability of Jenkinsfiles.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
