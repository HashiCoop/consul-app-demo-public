provider "google" {
  project     = "hc-0a4bbbd93e1449aea8902b850d9"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "gcp_cluster" {
  name     = "consul-autopilot"
  location = "us-central1-c"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gcp_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gcp_cluster.master_auth[0].cluster_ca_certificate)

  alias = "gcp"
}

resource "kubernetes_namespace" "gcp_consul" {
  provider = kubernetes.gcp

  metadata {
    name = "consul"
  }
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.gcp_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.gcp_cluster.master_auth[0].cluster_ca_certificate)
  }

  alias = "gcp"
}

resource "helm_release" "gcp_consul" {
  provider = helm.gcp

  name      = "consul"
  namespace = kubernetes_namespace.gcp_consul.metadata[0].name

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = [
    "${file("config/gcp-consul-values.yaml")}"
  ]
}

data "kubernetes_secret" "gcp_consul_bootstrap_acl_token" {
  provider = kubernetes.gcp

  metadata {
    name = "consul-bootstrap-acl-token"
    namespace = helm_release.gcp_consul.namespace
  }
}

data "kubernetes_service" "gcp_consul_ui" {
  provider = kubernetes.gcp

  metadata {
    name = "consul-ui"
    namespace = helm_release.gcp_consul.namespace
  }
}

output "gcp_consul_bootstrap_acl_token" {
  value = nonsensitive(data.kubernetes_secret.gcp_consul_bootstrap_acl_token.data)
} 

output "gcp_consul_ui_endpoint" {
  value = data.kubernetes_service.gcp_consul_ui.status[0].load_balancer[0].ingress[0].ip
}