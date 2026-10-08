output "tf_runner_role_arn" {
  value = module.tf_runner.role_arn
}

output "tf_deployer_role_arn" {
  value = module.tf_deployer.role_arn
}

output "route53_deployer_role_arn" {
  value = module.route53_deployer.role_arn
}

output "codepipeline_role_arn" {
  value = module.codepipeline_role.role_arn
}

output "codebuild_role_arn" {
  value = module.codebuild_role.role_arn
}

