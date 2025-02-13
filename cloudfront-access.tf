## CLoudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "cloudfront" {
  count   = var.origin_access_identity ? 1 : 0
  comment = "Origin Access Identity for S3 bucket"
}

## CLoudfront origin access control
resource "aws_cloudfront_origin_access_control" "cloudfront" {
  count                             = var.origin_access_control ? 1 : 0
  name                              = var.name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

