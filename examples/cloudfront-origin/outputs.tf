output "bucket_arn" {
  value = module.s3.bucket_arn
}

output "bucket_arn_oac" {
  value = module.s3_oac.bucket_arn
}

output "bucket_regional_domain_name" {
  value = module.s3.bucket_regional_domain_name
}

output "bucket_regional_domain_name_oac" {
  value = module.s3_oac.bucket_regional_domain_name
}

output "cloudfront_access_identity_path" {
  value = var.origin_access_identity ? module.s3.cloudfront[0].origin_access_identity_path : null
}

output "cloudfront_access_control_id" {
  value = var.origin_access_control ? module.s3_oac.cloudfront[0].origin_access_control_id : null
}

output "bucket_name" {
  value = module.s3_oac.bucket_name
}

output "bucket_name_oac" {
  value = module.s3_oac.bucket_name
}