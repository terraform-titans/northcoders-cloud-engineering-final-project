provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "project-frontend" {
  provider = aws.us_east_1

  repository_name = "project-frontend"
  }