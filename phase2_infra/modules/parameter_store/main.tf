resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name        = "/website/cloudfront/distribution-id"
  description = "CloudFront distribution ID"
  type        = "String"
  value       = var.cloudfront_distribution_id
}