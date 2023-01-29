data "tfe_outputs" "consul" {
  organization = var.TFC_ORG
  workspace    = var.TFC_CONSUL_WORKSPACE
}

provider "consul" {
  address        = data.tfe_outputs.consul.values.aws_consul_auth.address
  token          = data.tfe_outputs.consul.values.aws_consul_auth.token
  scheme         = "https"
  insecure_https = true
}
