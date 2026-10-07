# create terraform deploy role in dev
resource "aws_iam_role" "tf_deployer" {
  name = "tf-deployer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = [
          var.tf_runner_role_arn,
          "arn:aws:iam::${var.shared_account_id}:root"
        ]

      }
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_iam_policy_document" "tf_deployer" {

  # --- s3 all permissions ---
  statement {
    sid    = "FullS3Access"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }

  # --- CLOUDFRONT BASIC ---
  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig"
    ]
    resources = ["*"]
  }

  # --- CLOUDFRONT MANAGEMENT ---
  statement {
    sid    = "CloudFrontManagement"
    effect = "Allow"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:CreateFunction",
      "cloudfront:PublishFunction",
      "cloudfront:DescribeFunction",
      "cloudfront:GetFunction",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:DeleteFunction",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:ListTagsForResource"
    ]
    resources = ["*"]
  }

  # --- ACM CERTIFICATES ---
  statement {
    sid    = "ACMAccess"
    effect = "Allow"
    actions = [
      "acm:RequestCertificate",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:DeleteCertificate",
      "acm:GetCertificate",
      "acm:ListTagsForCertificate"
    ]
    resources = ["*"]
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
      "arn:aws:ssm:${var.region}:${var.dev_account_id}:parameter/website/cloudfront/distribution-id"
    ]
  }

  statement {
    sid       = "SSMDescribeParameters"
    effect    = "Allow"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

}

resource "aws_iam_role_policy" "this" {
  role   = aws_iam_role.tf_deployer.name
  policy = data.aws_iam_policy_document.tf_deployer.json
}
