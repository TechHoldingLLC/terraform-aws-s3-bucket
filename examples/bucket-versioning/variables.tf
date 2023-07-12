variable "name" {
  description = "S3 bucket name"
  type        = string
}

variable "versioning" {
  description = "Set bucket versioninig"
  type        = string
  default     = "Disabled"
}