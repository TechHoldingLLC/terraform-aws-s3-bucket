module "s3" {
  source     = "../../"
  name       = "my-unique-lambda-artifacts"
  versioning = "Enabled"
  lifecycle_rule = [
    {
      id                                     = "remove-previous-versions"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 1
      expiration = {
        days                         = 0
        expired_object_delete_marker = true
      }
      noncurrent_version_expiration = {
        days = 7
      }
    }
  ]

  providers = {
    aws = aws
  }
}