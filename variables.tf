variable "bucket_public_read_access" {
  description = "Allow public read to objects when website enabled"
  type        = bool
  default     = false
}

variable "bucket_public_read_access_condition" {
  description = "Allow public read to objects with condition when website enabled"
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "S3 bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Force bucket destroy"
  type        = string
  default     = false
}

variable "origin_access_identity" {
  description = "Configure cloudfront origin access identity"
  default     = false
  type        = bool
}

variable "origin_access_control" {
  description = "Configure cloudfront origin access control"
  default     = false
  type        = bool
}

variable "versioning" {
  description = "Set bucket versioninig"
  type        = string
  default     = "Disabled"
}

variable "website" {
  description = "Configure bucket to host static website"
  type        = any
  default     = {}
}

variable "cloudfront_arn" {
  description = "CloudFront ARN"
  type        = string
  default     = ""
}

variable "encryption_algorithm" {
  description = "Algorithm used for SSE in s3"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "KMS master key ID used for the SSE-KMS encryption"
  type        = string
  default     = null
}

variable "lifecycle_rule" {
  description = "S3 lifecycle rule for objects"
  default     = []
}

variable "create_lifecycle_rule" {
  description = "Create s3 lifecycle rule"
  default     = false
}

variable "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS"
  type        = bool
  default     = true
}

variable "https_enabled" {
  description = "Deny all the HTTP requests in bucket"
  type        = bool
  default     = true
}
