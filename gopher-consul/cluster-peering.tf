variable "AWS_CONSUL_TOKEN" {
    type = string
}

variable "GCP_CONSUL_TOKEN" {
    type = string
}

provider "consul" {
  alias          = "aws"
  address        = "a9e78ecc71269441da66304cd477764d-1559337923.us-east-1.elb.amazonaws.com"
  token          = var.AWS_CONSUL_TOKEN
  scheme         = "https"
  insecure_https = true
}

resource "consul_peering_token" "aws-gcp" {
  provider  = consul.aws
  peer_name = "gcp-cluster"
}

provider "consul" {
  alias          = "gcp"
  #address        = data.kubernetes_service.gcp_consul_ui.status[0].load_balancer[0].ingress[0].ip
  #token          = data.kubernetes_secret.gcp_consul_bootstrap_acl_token.data.token
  address       = "34.136.236.23"
  token = var.GCP_CONSUL_TOKEN
  scheme         = "https"
  insecure_https = true
}

# resource "kubernetes_manifest" "mesh_gateway" {
#   manifest  = yamldecode(file("./config/mesh-gw.yaml"))

# }

# resource "kubernetes_manifest" "gcp_mesh_gateway" {
#   provider  = kubernetes.gcp
#   manifest  = yamldecode(file("./config/mesh-gw.yaml"))
# }

# resource "consul_peering" "gcp-aws" {
#   provider = consul.gcp

#   peer_name     = "aws-cluster"
#   peering_token = consul_peering_token.aws-gcp.peering_token

#   meta = {
#     hello = "world"
#   }

#   depends_on = [
#     kubernetes_manifest.gcp_mesh_gateway
#   ]
# }
