provider "consul" {
  alias = "aws"

  address        = module.aws_consul.consul_ui_endpoint.hostname
  token          = module.aws_consul.consul_bootstrap_acl_token
  scheme         = "https"
  insecure_https = true
}

provider "consul" {
  alias   = "gcp"

  address        = module.aws_consul.consul_ui_endpoint.hostname
  token          = module.aws_consul.consul_bootstrap_acl_token
  scheme         = "https"
  insecure_https = true
}

resource "consul_config_entry" "mesh" {
  for_each = [provider.aws, provider.consul]
  provider = each.value

  name      = "mesh"
  kind      = "mesh"
  partition = "default"
  namespace = "consul"

  config_json = jsonencode({
      PeerThroughMeshGateways = true
  })
}

resource "consul_peering_token" "aws-gcp" {
  provider  = consul.aws
  peer_name = "gcp-cluster"
}

resource "consul_peering" "gcp-aws" {
  provider = consul.gcp

  peer_name     = "aws-cluster"
  peering_token = consul_peering_token.aws-gcp.peering_token

  depends_on = [
    kubernetes_manifest.gcp_mesh_gateway
  ]
}
