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