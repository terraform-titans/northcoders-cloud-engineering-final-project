# Provisioning S3 bucket for remote state backend

resource "aws_s3_bucket" "remote_backend" {
  bucket = "tt_remote_backend"

  tags = {
    Name        = "remote_backend"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "remote_backend" {
  bucket = "tt_remote_backend"
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "remote_backend" {
  depends_on = [aws_s3_bucket_ownership_controls.remote_backend]

  bucket = "tt_remote_backend"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning_name" {
  bucket = "tt_remote_backend"
  versioning_configuration {
    status = "Enabled"
  }
}