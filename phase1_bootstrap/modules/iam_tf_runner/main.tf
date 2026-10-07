resource "aws_iam_role" "tf_runner" {
  name = "tf-runner"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
        AWS     = "arn:aws:iam::131912109614:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_iam_policy_document" "tf_runner" {
  statement {
    sid    = "TerraformStateBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket_name}"
    ]
  }

  statement {
    sid    = "TerraformStateObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket_name}/*"
    ]
  }

  statement {
    sid     = "AssumetfDeployerRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${var.dev_account_id}:role/tf-deployer",
      "arn:aws:iam::${var.management_account_id}:role/route53-deployer"
    ]
  }

  # --- SSM PARAMETER STORE ---
  statement {
    sid    = "SSMParameterAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:AddTagsToResource",
      "ssm:DescribeParameters",
      "ssm:ListTagsForResource"
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${var.shared_account_id}:parameter/website/infra/*"
    ]
  }
}

resource "aws_iam_role_policy" "tf_runner" {
  role   = aws_iam_role.tf_runner.name
  policy = data.aws_iam_policy_document.tf_runner.json
}