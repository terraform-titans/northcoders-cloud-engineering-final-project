# Northcoders - Cloud Engineering - Final Group Project

### Designed by Joseph Adams, Joshua Stride, & Laura Woollard

The final group project in fullfillment of Northcoders' Cloud Engineering bootcamp; a full-stack web application deployed using the software development and cloud architecture knowledge we have developed over the past thirteen weeks, including:
- JavaScript, HTML5, CSS3, React, & Vite
- Java, Maven, Springboot, Spring Actuator, & Spring JDBC
- Amazon Web Services:
  - VPCs
  - ...
- Infrastructure as Code tooling:
  - Terraform
- Containerisation with Docker
- ...

## Getting started...

The following setup guide assumes access to an AWS account, as well as local installation  of: ArgoCD, CircleCI, Docker, Helm, Kubernetes & kubectl, and Terraform.

You will also need to configure your AWS account to work with the AWS CLI and Terraform... **[This needs to be worked on]**

## Provisioning a VPC

Immediately we will start provisioning infrastructure using Terraform. This means that we are already adherant to _The Golden Rule of Terraform_: once you've used Terraform, **only** use Terraform! Specficially we are going to provision a Virtual Private Cloud (VPC) onto which we will deploy our application.

### Remote State Backend

Before we can do this, however, we need to setup a secure **remote state backend** to improve security, reliability, and to facilitate teamwork in the development and operation of the software. A neater approach would be to provision an S3 bucket and DynamoDB table externally to this project, however for the purposes of knowledge exchange, we have included the neccesary configuration in this repository.

1) Firstly you need to specify the name we want to use for our remote state S3 bucket by specifying it as a variable value in the `.tfvars` file, and hardcoding the same value into line 6 of the `remote-state/backend.tf` file.
2) We can now run the config. In the `remote-state` directory: `providers.tf` and `backend.tf` **having commented out the terraform block therein**.
3) Once the S3 bucket and DynamoDB table have been provisioned, **uncommment** the terraform block and run `terraform init` to intialize the remote state backend.

### Virtual Private Cloud

We can now navigate to the `infrastructure` directory and run `terraform apply` to provision our VPC. **[Does the user just need to run `terraform apply` and the thing will deploy?]**

**[User won't need to deploy kubernetes, because Argo will do it??]**

### EKS 
By running `terraform apply` in the previous step, this will have created an empty Elastic Kuberneters Service cluster where our frontend and backend services will be deployed.
EKS is a managaed Kubernetes service that allows you to run Kubernetes on AWS. The frontend and backend will be deployed as nodes, where they can be accessed through the internet and communicate with one another to link up the different services. In this development environment, only 1 replica of each has been deployed to keep costs low. In production, more replicas would be deployed to share the load of increased traffic, to keep availabilty and reliability high. EKS will also automatically run health check on nodes, and if unhealthy, restart them and reroute traffic away from that node whilst the problem is being fix.

### RDS
The deployed application uses a Amazon Relational Database Service (RDS) database to store user information, allowing users to create and log into their accounts from different machines. For this project, the database has already been set up and the EKS deployment accesses it by using the credentials including username, password, name, endpoint of the database and the port through which to access the database. The database was configured with public access and an ingress security group allowing access through the corresponding postgreSQl port 5432. To keep costs low, a smaller database has been used in the devlopment stage. When going to production, it is likely a bigger database will need to be configured. 

### Helm
The original Kubernetes deployment and service charts were refactored into Helm charts. The Helm charts did not make any changes to the deployment of the applications, but was a way to better organise the deployment and service files, and allowed for a more efficient way to update the configuration of the deployment. It will look similiar to the following:<br>
**public.ecr.aws/a1b2c3d4/node-api-circleci**

The user may need to reconfigure these Helm charts. Specifically, in the  **values.yaml** for the frontend and backend, the **image repository** (line 8) may need to be changed to the **URI** of the corressponding frontend/ backend ECR repositiroy. The URIs for the frontend and backend can be found by going into public reposisotires in Amazon Elastic Container Service. 

### CircleCi
CircleCi is the platform used for the continuous integration stage of the CI/CD pipeline. When new code is pushed to the main branch of this repository, CircleCi will build the image of the frontend and backend and run each of the test scripts. If all the code compiles without errors and the tests pass, the updated images will be pushed up to their corresponding ECR repositories. This means that new code can be constantly integrated into the ECR image repository. 

Firstly, config.yml in .circleci must be set up. This is the configuration file that CircleCi will use to build images and run tests on them in the correct order. Look through this file if you wish to gain a better understanding. Some changes may be necessary for the config.yml to ensure it uses the correct ECR repository. 
The **public-registry-alias for the frontend and backend (lines 50 and lines 73 in config.ymal)** will need to be changed to match your public registry alias. This is the set of letters and numbers found in the URI of your public repositories, between public.ecr.aws/ and the repository name. <br>
If your URI is: <br>
**public.ecr.aws/a1b2c3d4/node-api-circleci**<br>
Your public-registary-alias will be: <br>
**a1b2c3d4**

After, you will need to set up the relevant permissions.To step this up, first head to CircleCi and sign in/up using the same GitHub account that has access to this repository. In Projects, there should be a list of your repositories. Select Set Up Project on the relevant project, select Fastest and type main in From which branch.

After this you will need to set up some credentials.
1) Head to IAM in AWS.
2) Under Users, select Add users. Give yourself user a username and select next.
3) In Permission options, select Attach policies directly.
4) In Permission policies, search for and select: <br>
**AmazonElasticContainerRegistaryFullAccess** <br>
**AmazonEC2ContainerRegistaryFullAccess**
5) Select Next and Create User.
6) Once it has been created, go to Security credentials in the new user.
7) Create Access Key and select Third-party Service.
8) Set a description and then Create Access Key. This will give you an Access key and Secret access key.
9) Select Download .csv file so you can access them.

Once you have created the relevant AWS access credentials, they need to be applied to the CircleCi project.
1) Go into Project Settings of your project and into environment variables.
2) Select Add Environment Variable and add the following variables:
```
AWS_ACCESS_KEY_ID - Value will be inside .csv file
AWS_ECR_REGISTRY_ID - Value is your 12 digit AWS Account ID
AWS_SECRET_ACCESS_KEY - Value will be inside .csv file
```
Whenever new code is pushed to GitHub, CircleCi will now automatically run tests on it and push the images up to the relevant ECR repository.

### Lambda
When provisioned in the AWS console, the lambda function was able to automatically send an email to the owner alterting them when a new user signs up for the application, and an email to the new user welcoming them. However, integrating the function into the Terraform configuration is still being worked on. When fully integrated, it will create the Lambda function through Terraform and assign it all the relevant roles and policies. The code for the Lambda function can be found in **index.mjs** in the **infrastucture** directory.

Furthermore, Amazon Simple Email Service (the service Lambda uses to send emails) is in Sandbox mode. This means we can only send emails to email addresses verified in Verified identities. To get into production mode where emails can be sent to unverified addresses (new users who have just created an acount in our application), a request needs to be sent to Amazon, where it will be reviewed.