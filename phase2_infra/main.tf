# S3 bucket to host static website in dev account
module "resume_site_bucket" {
  providers = {
    aws = aws.dev
  }
  source                      = "./modules/s3_static_site"
  bucket_name                 = var.bucket_name
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}



# retrieving certificate in us-east-1 in dev account 
data "aws_acm_certificate" "cert" {
  provider    = aws.acm
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# deploying CloudFront to route web traffic to s3 bucket
module "cloudfront" {
  providers = {
    aws = aws.dev
  }
  source = "./modules/cloudfront"

  bucket_regional_domain_name = module.resume_site_bucket.bucket_regional_domain_name
  acm_certificate_arn         = data.aws_acm_certificate.cert.arn

  aliases = [
    var.domain_name,
    var.www_domain_name
  ]
}

# creating a dns record in management account
module "dns" {
  source = "./modules/route53_cross_account"

  providers = {
    aws = aws.dns
  }

  zone_id = var.route53_zone_id

  records = {
    root = {
      name = var.domain_name
      type = "A"

      alias = {
        name                   = module.cloudfront.domain_name
        zone_id                = module.cloudfront.hosted_zone_id
        evaluate_target_health = false
      }
    }

    www = {
      name = var.www_domain_name
      type = "A"

      alias = {
        name                   = module.cloudfront.domain_name
        zone_id                = module.cloudfront.hosted_zone_id
        evaluate_target_health = false
      }
    }
  }
}

# storing the CloudFront distribution id in dev ssm parameter store
module "parameter_store" {
  source = "./modules/parameter_store"
  providers = {
    aws = aws.dev
  }
  cloudfront_distribution_id = module.cloudfront.distribution_id
}