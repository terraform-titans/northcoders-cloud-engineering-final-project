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
You need to make sure you are logged in to your AWS account via the terminal with your AWS credentials.

## Provisioning a VPC

Immediately we will start provisioning infrastructure using Terraform. This means that we are already adherant to _The Golden Rule of Terraform_: once you've used Terraform, **only** use Terraform! Specficially we are going to provision a Virtual Private Cloud (VPC) onto which we will deploy our application.

### Remote State Backend

Before we can do this, however, we need to setup a secure **remote state backend** to improve security, reliability, and to facilitate teamwork in the development and operation of the software. A neater approach would be to provision an S3 bucket and DynamoDB table externally to this project, however for the purposes of knowledge exchange, we have included the neccesary configuration in this repository.

1) Firstly you need to specify the name we want to use for our remote state S3 bucket by specifying it as a variable value in the `.tfvars` file, and hardcoding the same value into line 6 of the `remote-state/backend.tf` file.
2) We can now run the config. In the `remote-state` directory: `providers.tf` and `backend.tf` **having commented out the terraform block therein**.
3) Once the S3 bucket and DynamoDB table have been provisioned, **uncommment** the terraform block and run `terraform init` to intialize the remote state backend.

### Virtual Private Cloud and Elastic Kubernetes Service

We can now navigate to the `infrastructure` directory and run `terraform apply` to provision our VPC. 

By running `terraform apply`, this will also create the empty EKS cluster.

### Elastic Container Registry

Here we will create the Elastic Container Registry repositories. This is where the docker image for the frontend and backend will be stored.

To complete the next step, you will need to navigate to the ECR folders. You then need to run `terraform init` and then `terraform apply` in each of the folders (e.g. ecr-terraform-be then ecr-terraform-fe).

### CircleCI

When we open up circleCI, it will first of all build a docker image for us, which hold the

To push up the docker images, you will need to set up circleCI. This is a continuous deployment service


1) 
2)

### Argo 

To access ArgoCD, you will first need to make sure you are in the correct kubernetes context. To do this please run 

`aws eks --region eu-west-2 update-kubeconfig \ 
    --name tt-project-cluster`

We now need to set up the Argo namespace through:

`kubectl create namespace argocd` 

and then download and apply the argo yaml:

`kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml` 

To check this has all gone through and you are set up correctly, yyou can use this command:

`kubectl get pods -n argocd`

To access Argo, you will need to port-forward and you will need two terminals for this.
Using the port which is given to you next to argocd-server when you run `kubectl get pods -n argocd`.

Run this in one of your terminals:
`kubectl port-forward svc/argocd-server -n argocd 8080:443` and then log on to your browser and access localhost:8080. You should see the argo homepage.  In your other terminal, run this command which will give you the password needed to log-in on the browser with the username as **admin**. 

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

On the ArgoCD dashboard, you will need to navigate to the repo section and add this repo to argo. You will need to use a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)


- set up repo
- set up b/e app
- set up f/e app
- set up prometheus app



**[User won't need to deploy kubernetes, because Argo will do it??]** 
