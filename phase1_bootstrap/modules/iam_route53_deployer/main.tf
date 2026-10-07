resource "aws_iam_role" "route53_deployer" {
  name = "route53-deployer"

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

data "aws_iam_policy_document" "route53_deployer" {
  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:GetHostedZone",
      "route53:GetChange",
      "acm:ListCertificates",
      "acm:DescribeCertificate",
      "acm:GetCertificate",
      "acm:ListTagsForCertificate"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "route53_deployer" {
  role   = aws_iam_role.route53_deployer.name
  policy = data.aws_iam_policy_document.route53_deployer.json
}