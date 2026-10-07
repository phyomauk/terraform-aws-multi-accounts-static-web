# ----------------------------
# CodeBuild: Deploy Application codes
# ----------------------------
locals {
  build_project_name = "website-deploy"
}

resource "aws_codebuild_project" "deploy" {
  name         = local.build_project_name
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/../../buildspecs/deploy.yml")
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "TARGET_BUCKET"
      value = var.target_bucket
    }

    environment_variable {
      name  = "DEPLOY_ROLE_ARN"
      value = var.deploy_role_arn
    }

    environment_variable {
      name  = "TF_RUNNER_ROLE_ARN"
      value = var.tf_runner_role_arn
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild_infra.name
      stream_name = "build-log"
    }
  }
}

resource "aws_cloudwatch_log_group" "codebuild_infra" {
  name              = "/aws/static-site-project/codebuild/${local.build_project_name}"
  retention_in_days = 30
}