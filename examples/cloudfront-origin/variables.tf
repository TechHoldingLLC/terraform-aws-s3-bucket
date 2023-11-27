variable "origin_access_identity" {
  description = "Configure cloudfront access identity"
  default     = false
  type        = bool
}

variable "origin_access_control" {
  description = "Configure cloudfront access control"
  default     = false
  type        = bool
}