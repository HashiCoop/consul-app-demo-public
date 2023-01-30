data "tfe_outputs" "consul" {
  organization = var.TFC_ORG
  workspace    = var.TFC_CONSUL_WORKSPACE
}

variable "GCP_CONSUL_TOKEN" {
  type = string
}

provider "consul" {
  # address        = data.tfe_outputs.consul.values.gcp_consul_auth.address
  address = "https://34.68.143.78"
  # token          = data.tfe_outputs.consul.values.gcp_consul_auth.token
  token = var.GCP_CONSUL_TOKEN
  scheme         = "https"
  insecure_https = true
}
