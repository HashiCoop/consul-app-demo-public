provider "kubernetes" {
  host                   = var.KUBERNETES_AUTH.host
  token                  = var.KUBERNETES_AUTH.token
  cluster_ca_certificate = var.KUBERNETES_AUTH.cluster_ca_certificate
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = var.CONSUL_NAMESPACE
  }
}

provider "helm" {
  kubernetes {
    host                   = var.KUBERNETES_AUTH.host
    token                  = var.KUBERNETES_AUTH.token
    cluster_ca_certificate = var.KUBERNETES_AUTH.cluster_ca_certificate
  }
}

resource "helm_release" "consul" {
  name      = var.CONSUL_NAME
  namespace = kubernetes_namespace.consul.metadata[0].name

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = var.CONSUL_VALUES
}

data "kubernetes_secret" "consul_bootstrap_acl_token" {
  metadata {
    name = "consul-bootstrap-acl-token"
    namespace = helm_release.consul.namespace
  }
}

data "kubernetes_service" "consul_ui" {
  metadata {
    name = "consul-ui"
    namespace = helm_release.consul.namespace
  }
}