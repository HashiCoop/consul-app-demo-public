provider "consul" {
  alias = "aws"

  address        = module.aws_consul.consul_ui_endpoint.hostname
  token          = module.aws_consul.consul_bootstrap_acl_token
  scheme         = "https"
  insecure_https = true
}

provider "consul" {
  alias   = "gcp"

  address        = module.gcp_consul.consul_ui_endpoint.ip
  token          = module.gcp_consul.consul_bootstrap_acl_token
  scheme         = "https"
  insecure_https = true
}

output "gcp_consul_host" {
  value = "https://${module.gcp_consul.consul_ui_endpoint.ip}"
}

# resource "consul_config_entry" "aws_mesh_gateway" {
#   provider = consul.aws

#   name      = "mesh"
#   kind      = "mesh"

#   config_json = jsonencode({
#     Peering = {
#       PeerThroughMeshGateways = true
#     }
#   })
# }

# resource "consul_config_entry" "gcp_mesh_gateway" {
#   provider = consul.gcp

#   name      = "mesh"
#   kind      = "mesh"

#   config_json = jsonencode({
#     Peering = {
#       PeerThroughMeshGateways = true
#     }
#   })
# }

# resource "consul_peering_token" "aws_gcp" {
#   provider  = consul.aws

#   peer_name = "gcp-us-central1-c"

#   depends_on = [
#         consul_config_entry.aws_mesh_gateway
#   ]
# }

# resource "consul_peering" "aws_gcp" {
#   provider = consul.gcp

#   peer_name     = "aws-us-east-1"
#   peering_token = consul_peering_token.aws_gcp.peering_token

#   depends_on = [
#     consul_config_entry.gcp_mesh_gateway
#   ]
# }