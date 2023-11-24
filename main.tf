#tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy tfsec:ignore:aws-s3-ignore-public-acls tfsec:ignore:aws-s3-no-public-buckets tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "s3" {
  bucket        = var.name
  force_destroy = var.force_destroy

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      policy,
      website
    ]
  }
}

## encryption
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_algorithm
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