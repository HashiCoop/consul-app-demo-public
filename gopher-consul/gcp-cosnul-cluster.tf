data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = "consul-autopilot"
  location = "us-central1-c"
}

module "gcp_consul" {
  source = "./modules/consul-k8s-cluster"

  CONSUL_VALUES = ["config/gcp-consul-values.yaml"]
  
  KUBERNETES_AUTH = {
    host  = data.google_container_cluster.cluster.endpoint
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  }
}

output "aws_consul_bootstrap_acl_token" {
  value = nonsensitive(module.gcp_consul.consul_bootstrap_acl_token)
} 

output "aws_consul_ui_endpoint" {
  value = module.gcp_consul.consul_ui_endpoint.hostname
}