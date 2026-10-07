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
  alias   = "shared"
  profile = "shared"
  region  = var.region
}

provider "aws" {
  alias   = "dev"
  profile = "dev"
  region  = var.region
}

provider "aws" {
  alias   = "management"
  profile = "management"
  region  = var.region
}

