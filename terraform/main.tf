terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

provider "aws" {
    region = var.default_aws_region
}

resource "aws_s3_bucket" "static_web_bucket" {
    bucket = var.bucket_name

    tags = {
        Name = "s3_bucket_for_portfolio_website"
    }
}

resource "aws_s3_bucket_public_access_block" "portfolio_website" {
    bucket = aws_s3_bucket.static_web_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "portfolio_website" {
    bucket = aws_s3_bucket.static_web_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_website_configuration" "portfolio_website" {
    bucket = aws_s3_bucket.static_web_bucket.id

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "404.html"
    }
}

resource "aws_cloudfront_origin_access_control" "portfolio_website" {
    name                              = "static-website-oac"
    description                       = "Allow CloudFront to access S3"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "portfolio_website" {
    enabled             = true
    default_root_object = "index.html"

    origin {
        domain_name = aws_s3_bucket.static_web_bucket.bucket_regional_domain_name
        origin_id = "s3-origin"
    }

    default_cache_behavior {
        viewer_protocol_policy = "redirect-to-https"
        target_origin_id = "s3-origin"
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    price_class = "PriceClass_200"
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.static_web_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_web_bucket.arn}/*"
      }
    ]
  })
}