# provider "kubernetes" {
#   alias = "aws"
  
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
# }

# provider "kubernetes" {
#   alias = "gcp"
  
#   host  = "https://${data.google_container_cluster.cluster.endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
# }

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

resource "consul_config_entry" "aws_mesh_gateway" {
  provider = consul.aws

  name      = "mesh"
  kind      = "mesh"

  config_json = jsonencode({
    peering = {
      peerThroughMeshGateways = true
    }
  })
}

resource "consul_config_entry" "gcp_mesh_gateway" {
  provider = consul.gcp

  name      = "mesh"
  kind      = "mesh"

  config_json = jsonencode({
    peering = {
      peerThroughMeshGateways = true
    }
  })
}

# resource "kubernetes_manifest" "aws_mesh_gateway" {
#   provider = kubernetes.aws

#   manifest = yamldecode(file("config/mesh-gw.yaml"))

# }

# resource "kubernetes_manifest" "gcp_mesh_gateway" {
#   provider = kubernetes.gcp

#   manifest = yamldecode(file("config/mesh-gw.yaml"))
# }

resource "consul_peering_token" "aws_gcp" {
  provider  = consul.aws

  peer_name = "gcp-us-central1-c"

  depends_on = [
        consul_config_entry.aws_mesh_gateway
  ]
}

resource "consul_peering" "aws_gcp" {
  provider = consul.gcp

  peer_name     = "aws-us-east-1"
  peering_token = consul_peering_token.aws_gcp.peering_token

  depends_on = [
    consul_config_entry.gcp_mesh_gateway
  ]
}