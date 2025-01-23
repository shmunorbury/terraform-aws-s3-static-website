terraform {
  required_version = ">=1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }

}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}
