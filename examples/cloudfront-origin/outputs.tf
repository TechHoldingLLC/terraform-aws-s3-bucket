output "bucket_arn" {
  value = module.s3.bucket_arn
}

output "bucket_regional_domain_name" {
  value = module.s3.bucket_regional_domain_name
}

output "cloudfront_access_identity_path" {
  value = var.cloudfront_access_policy ? module.s3.cloudfront[0].cloudfront_access_identity_path : null
}

output "bucket_name" {
  value = module.s3.bucket_name
}