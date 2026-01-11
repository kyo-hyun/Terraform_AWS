locals {
  #security_key = yamldecode(file("C:/Users/khkim/OneDrive - Cnthoth. Co., Ltd/작업 폴더/khkim-lab/authentication_key/aws_key.yaml"))
  security_key = yamldecode(file("C:/Users/rygus/OneDrive - Cnthoth. Co., Ltd/작업 폴더/khkim-lab/authentication_key/aws_key.yaml"))
}

terraform {
  backend "local" {
    #path = "./terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }
  }

  required_version = ">=1.0"
}

provider "aws" {
  region     = "ap-northeast-2"
  access_key = local.security_key.authentication.test_account.access_key
  secret_key = local.security_key.authentication.test_account.secret_key
}