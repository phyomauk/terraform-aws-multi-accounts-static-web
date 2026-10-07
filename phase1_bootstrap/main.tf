# terraform runner role in shared account
module "tf_runner" {
  providers = {
    aws = aws.shared
  }
  source                      = "./modules/iam_tf_runner"
  management_account_id       = var.management_account_id
  dev_account_id              = var.dev_account_id
  terraform_state_bucket_name = var.terraform_state_bucket_name
  shared_account_id           = var.shared_account_id
  region                      = var.region
}

# terraform deployer role in dev account
module "tf_deployer" {
  providers = {
    aws = aws.dev
  }
  source             = "./modules/iam_tf_deployer"
  tf_runner_role_arn = module.tf_runner.role_arn
  bucket_name        = var.bucket_name
  dev_account_id     = var.dev_account_id
  shared_account_id  = var.shared_account_id
  region             = var.region
}

# dns record creator role in management account
module "route53_deployer" {
  providers = {
    aws = aws.management
  }
  source             = "./modules/iam_route53_deployer"
  tf_runner_role_arn = module.tf_runner.role_arn
  shared_account_id  = var.shared_account_id
}

# codepipeline role in shared account
module "codepipeline_role" {
  providers = {
    aws = aws.shared
  }
  source             = "./modules/iam_codepipeline"
  codeconnections_id = var.codeconnections_id
  shared_account_id  = var.shared_account_id
  region             = var.region
}

# codebuild role in shared account
module "codebuild_role" {
  providers = {
    aws = aws.shared
  }
  source               = "./modules/iam_codebuild"
  artifact_bucket_name = var.artifact_bucket_name
  tf_runner_role_arn   = module.tf_runner.role_arn
  dev_account_id       = var.dev_account_id
}

# ssm parameter store in shared account
module "ssm_parameter_store" {
  source                = "./modules/parameter_store"
  region                = var.region
  bucket_name           = var.bucket_name
  domain_name           = var.domain_name
  www_domain_name       = var.www_domain_name
  route53_zone_id       = var.route53_zone_id
  dev_account_id        = var.dev_account_id
  management_account_id = var.management_account_id
}

# artifact bucket
module "s3_artifact_bucket" {
  providers = {
    aws = aws.shared
  }
  source               = "./modules/s3_artifact"
  artifact_bucket_name = var.artifact_bucket_name
}

# codebuild for deploying codes to s3 
module "codebuild" {
  providers = {
    aws = aws.shared
  }
  source             = "./modules/codebuild_website"
  codebuild_role_arn = module.codebuild_role.role_arn
  deploy_role_arn    = module.tf_deployer.role_arn
  tf_runner_role_arn = module.tf_runner.role_arn
  target_bucket      = var.bucket_name
}

# codepipeline for website
module "codepipeline" {
  providers = {
    aws = aws.shared
  }

  source                 = "./modules/codepipeline"
  artifact_bucket_name   = module.s3_artifact_bucket.bucket_name
  repo_owner             = var.repo_owner
  repo_name              = var.repo_name
  codepipeline_role_arn  = module.codepipeline_role.role_arn
  codebuild_project_name = module.codebuild.name
  codeconnection_arn     = "arn:aws:codeconnections:${var.region}:${var.shared_account_id}:connection/${var.codeconnections_id}"
}

# codebuild for deploying infrastructure in dev account
module "codebuild_terraform" {
  providers = {
    aws = aws.shared
  }

  source             = "./modules/codebuild_terraform"
  codebuild_role_arn = module.codebuild_role.role_arn
  shared_account_id  = var.shared_account_id
}

# codepipeline for Infra
module "codepipeline_infra" {
  providers = {
    aws = aws.shared
  }

  source                 = "./modules/codepipeline_infra"
  artifact_bucket_name   = module.s3_artifact_bucket.bucket_name
  repo_owner             = var.repo_owner
  repo_name              = var.repo_name_tf
  codepipeline_role_arn  = module.codepipeline_role.role_arn
  codebuild_project_name = module.codebuild_terraform.name
  codeconnection_arn     = "arn:aws:codeconnections:${var.region}:${var.shared_account_id}:connection/${var.codeconnections_id}"
}