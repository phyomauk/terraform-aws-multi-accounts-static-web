variable "region" {
  default = "us-west-1"
}

variable "bucket_name" {
  description = "static website content bucket name"
}

variable "domain_name" {
  description = "your domain name"
  default     = "phyomauk.click"
}

variable "www_domain_name" {
  description = "your site domain name with prefix www"
  default     = "www.phyomauk.click"
}

variable "route53_zone_id" {
}

variable "dev_account_id" {

}

variable "management_account_id" {
}