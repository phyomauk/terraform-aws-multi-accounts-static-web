variable "bucket_name" {
  type = string
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "block_public_access" {
  type    = bool
  default = true
}

variable "cloudfront_distribution_arn" {
  default = "xxxxxxxx"
}
