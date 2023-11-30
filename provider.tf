terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "5.20.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
