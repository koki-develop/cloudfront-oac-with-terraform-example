output "cloudfront_main_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_legacy_domain_name" {
  value = aws_cloudfront_distribution.legacy.domain_name
}
