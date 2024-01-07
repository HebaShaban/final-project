# MySQL-and-Python
A small web app that allow users to create account, login, and make a bucket list.
This app is implemented using MySQL and Python. Copied from the tutorial http://code.tutsplus.com/tutorials/creating-a-web-app-from-scratch-using-python-flask-and-mysql--cms-22972

# FINAL-PROJECT
Sprints Final Project
# Setting up Jenkins with Terraform, Ansible, AWS, and GitHub

This guide outlines the steps to set up Jenkins for continuous integration and deployment using Terraform, Ansible, AWS, and GitHub. Follow these instructions to get your environment up and running.

After cloning the repo

## Step 1: Infrastructure Setup

1. Initialize Terraform:
```shell
terraform init
```
2. Plan and review the infrastructure changes:
 
```shell
terraform plan
```
3. Apply the infrastructure changes:
   
```shell
terraform apply
```
## Step 2: Install Tools

1. Run Ansible playbook to install Docker, AWS CLI, Kubernetes tools, and Jenkins:
   change the inventory file with the ip of your instance and add the key
   
```shell
ansible-playbook -i inventory docker.yml
```
```shell
ansible-playbook -i inventory awscli.yml
```
```shell
ansible-playbook -i inventory kubectl.yml
```
```shell
ansible-playbook -i inventory jenkins.yml
```

## Step 3: Jenkins Configuration 

1. Open ip of intstance with port 8080

2. Connect to your instance then retrieve the initial admin password:

```shell
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
3.Install suggested plugins then create a Jenkins  account:


## Step 4: Configure Jenkins Credentials:

1. To create jenkins credentials we acess Jenkins > manage Jenkins > credentials > system > global credentials 
   get aws credentials using

```shell
Cat .aws/credentials
```

2. Generate GitHub Token:

In your GitHub account, go to Settings > Developer settings > Personal access tokens.

Generate a new token with appropriate permissions.

Then add the credentials in jenkins as the previous step

## Step 5: Configure GitHub Webhook:

In your GitHub repository, go to Settings > Webhooks > Add webhook.

1. Payload URL with the Jenkins server's public IP and port 8080.
  
2. Change Content type to application/json

3. Which events would you like to trigger this webhook? the you choose (send me everything)

4. "Add Webhook"


## Step 6: Configure Jenkins Pipeline

1.get ecr url from aws add it to jenkins file in the approprtiate location

2.Create a Multibranch Pipeline in Jenkins

3.Create a new pipeline for your GitHub repository.

4.Configure credentials, repository URL, and branch discovery.

## Step 7: Run the Pipeline
Commit and push changes to your GitHub repository.
Jenkins will automatically trigger the pipeline on new commits and perform the defined actions.

1. run all kubernates files in jenkins to get app and database
2. run dockerfile, docker compose to get app and database




# ~ OUTPUT OF FINAL-PROJECT

# - INSTALL JENKINS BY ANSIBLE

# [heba1](https://github.com/HebaShaban/final-project/assets/128882939/f2215cc6-ee36-487f-9da7-0e04a8579934)

# - RUNNING THE PIPELINE IN JENKINS

# [run pipeline](https://github.com/HebaShaban/final-project/assets/128882939/62eafe97-ee92-4c69-9e2a-1a8ae4ea6b28)

# - RUNNING OF K8S IN EC2 WHICH INSTALLATION JENKINS

# [runinng k8s](https://github.com/HebaShaban/final-project/assets/128882939/f4c9d9b4-63a9-45c8-810c-a2e78866ba72)

# - RUNNING REPOSITORY APP WITH K8S IN JENKINS

# [db](https://github.com/HebaShaban/final-project/assets/128882939/5bf5dd26-0d66-45fd-99fa-2754c50d1a9a)

# - SIGN UP WITH DATABASE BY K8S IN JENKINS

# [before sign up](https://github.com/HebaShaban/final-project/assets/128882939/a62179e3-88b5-4889-9afc-1964dfaff578)

# - OUTPUT OF SIGN UP DATABASE OF K8S SUCCESSFULLY IN JENKINS

# [after sign up](https://github.com/HebaShaban/final-project/assets/128882939/9dbfab00-a811-41cd-ad0d-bc998483e087)

# - SIGN IN DATABASE IN APP BY K8S IN JENKINS

# !sign in](https://github.com/HebaShaban/final-project/assets/128882939/50a99917-c051-4168-b5ce-11d233b5d2e0)

# - RUNNING DOCKERFILE IN LOCALHOST

# [Screenshot 2023-08-06 034350](https://github.com/HebaShaban/final-project/assets/128882939/11f5a7a0-6aca-42f8-94ea-34defe658ca2)

# - RUNNING DATABASE IN APP BY DOCKER IN LOCALHOST

# [Screenshot 2023-08-06 034350](https://github.com/HebaShaban/final-project/assets/128882939/7e224e9a-c6cd-4f4f-a7a2-c5cdbda1b88d)

# [Screenshot 2023-08-06 033018](https://github.com/HebaShaban/final-project/assets/128882939/e510b93e-2c90-4656-ad8c-351c835be1b3)

# - RUNNING APP WITH DOCKER IN JENKINS

# [docker compose](https://github.com/HebaShaban/final-project/assets/128882939/f794335c-a662-4e95-92f2-24c8cbe1edf7)

# - RUNNING APP WITH DOCKER IN JENKINS

# [app docker](https://github.com/HebaShaban/final-project/assets/128882939/170a0a73-d201-4f4d-a301-756ca0375e8c)

# - SIGN UP IN DATABASE BY DOCKER IN JENKINS

# ![db after docker](https://github.com/HebaShaban/final-project/assets/128882939/9892a64e-68c9-42eb-ab03-bb97390dc57b)

# - SIGN IN DATABASE BY DOCKER IN JENKINS

# ![docker sign in](https://github.com/HebaShaban/final-project/assets/128882939/e36f6504-0cdf-4496-9f04-31e55207a7ed)




