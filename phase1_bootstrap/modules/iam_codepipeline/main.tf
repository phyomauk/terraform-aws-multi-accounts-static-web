resource "aws_iam_role" "codepipeline" {
  name = "shared-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
      "codebuild:*",
      "sts:AssumeRole"
    ]

    resources = [
      "*"
    ]
  }

  ############################################
  # GitHub connection
  ############################################
  statement {
    effect = "Allow"

    actions = [
      "codeconnections:UseConnection",
      "codestar-connections:UseConnection"
    ]

    resources = [
      "arn:aws:codestar-connections:${var.region}:${var.shared_account_id}:connection/${var.codeconnections_id}",
      "arn:aws:codeconnections:${var.region}:${var.shared_account_id}:connection/${var.codeconnections_id}"
    ]
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline.json

}