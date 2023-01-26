provider "consul" {
  alias          = "aws"
  address        = data.kubernetes_service.consul_ui.status[0].load_balancer[0].ingress[0].hostname
  token          = data.kubernetes_secret.consul_bootstrap_acl_token.data.token
  scheme ="https"
  insecure_https = true
}

provider "consul" {
  alias          = "gcp"
  address        = data.kubernetes_service.gcp_consul_ui.status[0].load_balancer[0].ingress[0].ip
  token          = data.kubernetes_secret.gcp_consul_bootstrap_acl_token.data.token
  scheme ="https"
  insecure_https = true
}

resource "kubernetes_manifest" "mesh_gateway" {
    manifest = yamldecode(file("./config/mesh-gw.yaml"))
}

resource "kubernetes_manifest" "gcp_mesh_gateway" {
    provider = kubernetes.gcp
    manifest = yamldecode(file("./config/mesh-gw.yaml"))
}

resource "consul_peering_token" "aws-gcp" {
  provider  = consul.aws
  peer_name = "gcp-cluster"

  depends_on = [
    kubernetes_manifest.gcp_mesh_gateway
  ]
}

resource "consul_peering" "gcp-aws" {
  provider = consul.gcp

  peer_name     = "aws-cluster"
  peering_token = consul_peering_token.aws-gcp.peering_token

  meta = {
    hello = "world"
  }

  depends_on = [
    kubernetes_manifest.gcp_mesh_gateway
  ]
}
