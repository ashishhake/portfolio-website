variable "default_aws_region" {
    default     = "ap-south-1"
}

variable "bucket_name" {
    type = string
    description = "S3 bucket name for static site"
    default     = "static-web-host-ash-2026"  
}

variable "bucket_id" {
    default = "aws_s3_bucket.static-web-bucket.id"
}