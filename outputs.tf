output "bucket_arn" {
  value = aws_s3_bucket.s3.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3.bucket_regional_domain_name
}

output "origin_access_identity_path" {
  value = var.origin_access_identity ? aws_cloudfront_origin_access_identity.cloudfront[0].cloudfront_access_identity_path : null
}

output "origin_access_control_id" {
  value = var.origin_access_control ? aws_cloudfront_origin_access_control.cloudfront[0].id : null
}

output "bucket_name" {
  value = aws_s3_bucket.s3.id
}

output "bucket_website_endpoint" {
  value = length(var.website) > 0 ? aws_s3_bucket_website_configuration.website[0].website_endpoint : null
}