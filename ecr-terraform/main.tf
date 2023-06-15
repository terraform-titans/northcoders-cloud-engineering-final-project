provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "project-backend-api" {
  provider = aws.us_east_1

  repository_name = "project-backend-api"
  }