variable "bucket_regional_domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "aliases" {
  type = list(string)
}

variable "enable_redirect_www" {
  type    = bool
  default = true
}