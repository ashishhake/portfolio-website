provider "aws" {
    region = var.default_aws_region
}

resource "aws_s3_bucket" "static-web-bucket" {

    bucket = var.bucket_name

    tags = {
        Name = "s3_bucket_for_portfolio_website"
    }

}

resource "aws_cloudfront_distribution" "CDN" {
    origin {

        domain_name = aws_s3_bucket.static-web-bucket.bucket_regional_domain_name
        origin_id = aws_s3_bucket.static-web-bucket.id
        origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id

    }

    default_cache_behavior {

        target_origin_id       = aws_s3_bucket.static-web-bucket.id
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods        = ["GET", "HEAD"]
        cached_methods         = ["GET", "HEAD"]

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    enabled = true
    default_root_object = "index.html"
}

resource "aws_cloudfront_origin_access_control" "OAC" {

    name = "my_oac"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"

}

data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static-web-bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.CDN.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static-web-bucket-policy" {
    bucket = aws_s3_bucket.static-web-bucket.id
    policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}

