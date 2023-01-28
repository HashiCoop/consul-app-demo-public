provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = var.CONSUL_NAMESPACE
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

resource "helm_release" "consul" {
  name      = "consul"
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

output "consul_bootstrap_acl_token" {
  value = nonsensitive(data.kubernetes_secret.consul_bootstrap_acl_token.data)
} 

output "consul_ui_endpoint" {
  value = data.kubernetes_service.consul_ui.status[0].load_balancer[0].ingress[0].hostname
}