terraform {
  backend "s3" {
    bucket = "phyomauk-terraform-state-shared"
    key    = "s3-site/runner/terraform.tfstate"
    region = "us-west-1"
    # profile      = "shared"
    use_lockfile = true
  }
}