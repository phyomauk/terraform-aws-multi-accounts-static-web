terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias = "dev"
  # profile = "shared"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${var.dev_account_id}:role/tf-deployer"
    session_name = "LocalRunnerSession"
  }
}

provider "aws" {
  alias = "acm"
  # profile = "shared"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.dev_account_id}:role/tf-deployer"
  }
}

provider "aws" {
  alias = "dns"
  # profile = "shared"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.management_account_id}:role/route53-deployer"
  }
}
