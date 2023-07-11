output "bucket_arn" {
  value = aws_s3_bucket.s3.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3.bucket_regional_domain_name
}

output "cloudfront_access_identity_path" {
  value = var.cloudfront_access_policy ? aws_cloudfront_origin_access_identity.cloudfront[0].cloudfront_access_identity_path : null
}

output "bucket_name" {
  value = aws_s3_bucket.s3.id
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket.s3.website_endpoint
}