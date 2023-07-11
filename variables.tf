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

variable "cloudfront_access_policy" {
  description = "Configure cloudfront access policy"
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