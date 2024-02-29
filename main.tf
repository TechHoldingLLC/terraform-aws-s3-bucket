#tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy tfsec:ignore:aws-s3-ignore-public-acls tfsec:ignore:aws-s3-no-public-buckets tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "s3" {
  bucket        = var.name
  force_destroy = var.force_destroy

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      website
    ]
  }
}

## Lifecycle rule configuartion
resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle_configuration" {
  count  = var.create_lifecycle_rule ? 1 : 0
  bucket = aws_s3_bucket.s3.id

  rule { # Without this it gives error "At least 1 "rule" blocks are required."
    id     = "default"
    status = "Disabled"
    dynamic "expiration" { # Without this it gives error "At least one action needs to be specified in a rule"
      for_each = var.lifecycle_rule
      content {
        days = lookup(expiration.value, "days", null)
      }
    }
  }

  dynamic "rule" {
    for_each = var.lifecycle_rule

    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "abort_incomplete_multipart_upload" {
        for_each = length(keys(lookup(rule.value, "abort_incomplete_multipart_upload", {}))) == 0 ? [] : [lookup(rule.value, "abort_incomplete_multipart_upload", {})]
        content {
          days_after_initiation = lookup(abort_incomplete_multipart_upload.value, "days_after_initiation", null)
        }
      }

      dynamic "expiration" {
        for_each = length(keys(lookup(rule.value, "expiration", {}))) == 0 ? [] : [lookup(rule.value, "expiration", {})]
        content {
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", false)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(rule.value, "noncurrent_version_expiration", {})]
        content {
          noncurrent_days = lookup(noncurrent_version_expiration.value, "noncurrent_days", null)
        }
      }
    }
  }
}

## encryption
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption_algorithm
      kms_master_key_id = var.encryption_algorithm == "AES256" ? null : var.kms_master_key_id
    }
  }
}

## versioning
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.versioning
  }
}

## Bucket Ownership
# To enable ACL, the object ownership should be set as BucketOwnerPreferred
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  count  = var.bucket_public_read_access ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## Public access
# To allow public access to objects
resource "aws_s3_bucket_public_access_block" "public_access" {
  count = var.bucket_public_read_access ? 1 : 0

  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

## ACL
resource "aws_s3_bucket_acl" "acl" {
  count = var.bucket_public_read_access ? 1 : 0

  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership,
    aws_s3_bucket_public_access_block.public_access,
  ]
  bucket = aws_s3_bucket.s3.id
  acl    = "public-read"
}