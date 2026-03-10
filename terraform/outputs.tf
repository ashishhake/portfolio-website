output "s3_bucket_name" {
  value = aws_s3_bucket.static_web_bucket.id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.portfolio_website.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.portfolio_website.domain_name
}