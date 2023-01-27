resource "kubernetes_namespace" "gcp_vault" {
    provider = kubernetes.gcp
  metadata {
    name = "orgchart"
  }
}

# resource "helm_release" "orgchart" {
#   provider  = helm.gcp
#   name      = "orgchart"
#   namespace = kubernetes_namespace.consul.metadata[0].name

#   repository = "https://helm.releases.hashicorp.com"
#   chart      = "consul"

#   values = [
#     file("config/deployment-orgchart.yaml")
#   ]
# }

resource "kubernetes_service_account" "example" {
    provider = kubernetes.gcp
  metadata {
    name = "internal-app"
  }
}

resource "kubernetes_manifest" "orgchart" {
    provider = kubernetes.gcp
  manifest = yamldecode(file("./config/deployment-orgchart.yaml"))
}

