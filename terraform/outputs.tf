output "CloudFront_distribution_ID" {
    value = aws_cloudfront_distribution.CDN.id
}

output "s3_bucket_name" {
    value = aws_s3_bucket.static-web-bucket.bucket
}