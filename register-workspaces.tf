module "auto-register-monorepo-workspaces" {
  source  = "app.terraform.io/hashicoop/auto-register-monorepo-workspaces/tfc"

  TFC_WORKSPACE_NAME = var.TFC_WORKSPACE_NAME
  OAUTH_CLIENT_ID = var.OAUTH_CLIENT_ID
}

variable "TFC_WORKSPACE_NAME" {}

variable "OAUTH_CLIENT_ID" {}