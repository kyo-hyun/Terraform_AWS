variable "user_profile" {}

locals {
  key_path = "C:/Users/${var.user_profile}/OneDrive - Cnthoth. Co., Ltd/작업 폴더/khkim-lab/authentication_key/aws_key.yaml"
  key      = yamldecode(file(local.key_path))

  account_name_map = {
    "364010288789" = "TEST 환경이니 안심하라구!"
  }

  current_account_name = lookup(local.account_name_map,data.aws_caller_identity.current.account_id,"unknown")
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
  access_key = local.key.authentication.test_account.access_key
  secret_key = local.key.authentication.test_account.secret_key
}

data "aws_caller_identity" "current" {}

output "current_aws_identity" {
  value = local.current_account_name
}