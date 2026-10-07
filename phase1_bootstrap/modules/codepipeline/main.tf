# ----------------------------
# CodePipeline
# ----------------------------
resource "aws_codepipeline" "this" {
  name     = "s3-static-site-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket_name
  }

  # wbesite codes  
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codeconnection_arn
        FullRepositoryId = "${var.repo_owner}/${var.repo_name}"
        BranchName       = var.branch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}