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

## Provisioning a VPC

Immediately we will start provisioning infrastructure using Terraform. This means that we are already adherant to _The Golden Rule of Terraform_: once you've used Terraform, **only** use Terraform! Specficially we are going to provision a Virtual Private Cloud (VPC) onto which we will deploy our application. Before we can do this, however, we need to setup a secure **remote state backend** to improve security, reliability, and to facilitate teamwork in the development and operation of the software.



