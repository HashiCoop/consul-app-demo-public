terraform {
  required_providers {
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.0"
    }
  }
}

data "doormat_aws_credentials" "creds" {
  role_arn = "arn:aws:iam::390101570318:role/${var.TFC_WORKSPACE_NAME}"
}
