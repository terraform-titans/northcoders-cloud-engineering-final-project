# Northcoders - Cloud Engineering - Final Group Project

### Designed by Joseph Adams, Joshua Stride, & Laura Woolard

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

It is first neccesary to run the config. in `providers.tf`:

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "eu-west-2"
}
```

and `backend.tf` **having commented out the terraform block**:

```
# terraform {
#   backend "s3" {
#     bucket = "tt-remote-backend"
#     key    = "backend/terraform.tfstate"
#     region = "eu-west-2"
#     dynamodb_table = "remote-backend"
#   }
# }

# NOTE: remote backend setup depends on below S3 & DynamoDB config
# Provisioning S3 bucket for remote state backend

resource "aws_s3_bucket" "remote-backend" {
  bucket = "tt-remote-backend"

  tags = {
    Name        = "remote-backend"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "remote-backend" {
  depends_on = [aws_s3_bucket.remote-backend]
  
  bucket = "tt-remote-backend"
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "remote-backend" {
  depends_on = [aws_s3_bucket_ownership_controls.remote-backend]

  bucket = "tt-remote-backend"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote-backend" {
  bucket = "tt-remote-backend"
  versioning_configuration {
    status = "Enabled"
  }
}

# Provsioning DynamoDB table for remote state backend

resource "aws_dynamodb_table" "remote-backend" {
  name         = "remote-backend"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

Once the S3 bucket and DynamoDB table have been provisioned, uncommment the terraform block and run `terraform init` to intialize the remote state backend.

### Virtual Private Cloud


