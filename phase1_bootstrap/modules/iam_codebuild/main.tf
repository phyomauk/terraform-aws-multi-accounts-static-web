# ----------------------------
# IAM: CodeBuild role in shared account
# ----------------------------
resource "aws_iam_role" "codebuild" {
  name = "shared-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# data "aws_iam_policy_document" "codebuild" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "sts:AssumeRole",
#       "logs:*",
#       "s3:*",
#       "cloudfront:CreateInvalidation"
#     ]

#     resources = [
#       "*"
#     ]
#   }
# }

data "aws_iam_policy_document" "codebuild" {

  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ArtifactBucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.artifact_bucket_name}",
      "arn:aws:s3:::${var.artifact_bucket_name}/*"
    ]
  }

  statement {
    sid    = "AssumeTfRunner"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      var.tf_runner_role_arn
    ]
  }

  statement {
    sid    = "CloudFrontInvalidation"
    effect = "Allow"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations"
    ]

    resources = [
      "arn:aws:cloudfront::${var.dev_account_id}:distribution/*"
    ]
  }

}

resource "aws_iam_role_policy" "codebuild" {
  role   = aws_iam_role.codebuild.name
  policy = data.aws_iam_policy_document.codebuild.json
}

