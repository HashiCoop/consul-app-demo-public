module "auto-register-monorepo-workspaces" {
  source  = "app.terraform.io/hashicoop/auto-register-monorepo-workspaces/tfc"
  version = "0.1.0"

  TFC_WORKSPACE_NAME = var.TFC_WORKSPACE_NAME
}

variable "TFC_WORKSPACE_NAME" {}

variable "OAUTH_CLIENT_ID" {}