# Comment out the below and provision an S3 bucket and DynamoDB table underneath
# Then uncomment the terraform block and run 'terraform init' to initialize the remote state backend

terraform {
  backend "s3" {
    bucket = "lauras-bucket2"
    key    = "backend/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "remote-backend"
  }
}

# NOTE: remote backend setup depends on below S3 & DynamoDB config
# Provisioning S3 bucket for remote state backend

resource "aws_s3_bucket" "remote-backend" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "remote-backend" {
  depends_on = [aws_s3_bucket.remote-backend]
  
  bucket = var.bucket_name
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "remote-backend" {
  depends_on = [aws_s3_bucket_ownership_controls.remote-backend]

  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote-backend" {
  bucket = var.bucket_name
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