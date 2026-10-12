terraform {
  backend "s3" {
    bucket = "gatekeeper-luk"
    key    = "gaterkeeper/terraform.tfstate"
    region = "us-east-1"
  }
}