output "id" {
  value = module.s3.bucket_name
}

output "arn" {
  value = module.s3.bucket_arn
}