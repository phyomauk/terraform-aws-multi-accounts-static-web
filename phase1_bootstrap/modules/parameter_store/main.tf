# aws region
resource "aws_ssm_parameter" "region" {
  name        = "/website/infra/region"
  description = "deployment region"
  type        = "String"
  value       = var.region
}

# s3 website bucket name
resource "aws_ssm_parameter" "s3_static_site_bucket" {
  name        = "/website/infra/bucket_name"
  description = "s3 static site bucket name"
  type        = "String"
  value       = var.bucket_name
}

# domain name
resource "aws_ssm_parameter" "domain_name" {
  name        = "/website/infra/domain_name"
  description = "domain name"
  type        = "String"
  value       = var.domain_name
}

# www domain name
resource "aws_ssm_parameter" "www_domain_name" {
  name        = "/website/infra/www_domain_name"
  description = "domain name with www prefix"
  type        = "String"
  value       = var.www_domain_name
}

# route53 zone id
resource "aws_ssm_parameter" "route53_zone_id" {
  name        = "/website/infra/route53_zone_id"
  description = "route 53 zone ID"
  type        = "String"
  value       = var.route53_zone_id
}

# dev account ID
resource "aws_ssm_parameter" "dev_account_id" {
  name        = "/website/infra/dev_account_id"
  description = "dev account id"
  type        = "String"
  value       = var.dev_account_id
}

# management account ID
resource "aws_ssm_parameter" "management_account_id" {
  name        = "/website/infra/management_account_id"
  description = "management account id"
  type        = "String"
  value       = var.management_account_id
}
