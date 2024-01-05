terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  default_tags {
    tags = {
      Project = var.project_tag
      Owner = var.owner_tag
      CreatedBy = "Terraform"
    }
  }
}