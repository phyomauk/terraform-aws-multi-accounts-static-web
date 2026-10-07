variable "region" {
  default = "us-west-1"
}

variable "dev_account_id" {
}

variable "management_account_id" {

}

variable "shared_account_id" {

}

variable "bucket_name" {
  description = "static site s3 bucket name"
  default     = "s3-static-site-phyomauk"
}

variable "terraform_state_bucket_name" {
  description = "s3 bucket in shared account - prerequisite"
  default     = "phyomauk-terraform-state-shared"
}


variable "codeconnections_id" {
  description = "the last 32 characters of the codeconnections arn - prerequisite"
}

variable "artifact_bucket_name" {
  description = "the codepipeline will store artifact in this bucket"
  default     = "shared-codepipeline-artifacts-s3-site-phyomauk"
}

variable "repo_owner" {
  description = "GitHub owner name - prerequisite"
  default     = "phyomauk"
}

variable "repo_name" {
  description = "the GitHub repo name of the website content stored repo - prerequisite"
  default     = "app-s3-static-website"
}

variable "repo_name_tf" {
  description = "the GitHub repo name of the terraform codes store - prerequisite"
  default     = "terraform-s3-static-website"
}

variable "branch" {
  default = "main"
}

variable "domain_name" {
  description = "domain name"
  default     = "phyomauk.click"
}

variable "www_domain_name" {
  description = "domain name with prefix www"
  default     = "www.phyomauk.click"
}

variable "route53_zone_id" {

}