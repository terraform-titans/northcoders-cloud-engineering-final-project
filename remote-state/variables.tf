variable "bucket_name" {
  description = "name of s3 bucket for remote state"
  type        = string
  default     = "unique_bucket_name"
}
