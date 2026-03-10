variable "default_aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for static site"
}
