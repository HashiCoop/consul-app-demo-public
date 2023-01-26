provider "consul" {
  alias   = "aws"
  address = data.kubernetes_service.consul_ui.status[0].load_balancer[0].ingress[0].hostname
  token = data.kubernetes_secret.consul_bootstrap_acl_token.data.token
}

provider "consul" {
  alias   = "gcp"
  address = data.kubernetes_service.gcp_consul_ui.status[0].load_balancer[0].ingress[0].ip
  token = data.kubernetes_secret.gcp_consul_bootstrap_acl_token.data.token
}

resource "consul_peering_token" "aws-gcp" {
  provider  = consul.aws
  peer_name = "gcp-cluster"
}

resource "consul_peering" "gcp-aws" {
  provider = consul.gcp

  peer_name     = "aws-cluster"
  peering_token = consul_peering_token.aws-gcp.peering_token

  meta = {
    hello = "world"
  }
}