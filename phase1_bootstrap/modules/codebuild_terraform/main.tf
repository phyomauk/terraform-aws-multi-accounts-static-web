locals {
  build_project_name = "dev-infra"
}
# Codebuild: deploy infra in dev account
resource "aws_codebuild_project" "tf_execution" {
  name         = local.build_project_name
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/../../buildspecs/tf.yml")
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "SHARED_ACCOUNT_ID"
      value = var.shared_account_id
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