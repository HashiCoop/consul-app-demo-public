# resource "kubernetes_namespace" "gcp_vault" {
#     provider = kubernetes.gcp
#   metadata {
#     name = "vault"
#   }
# }

resource "helm_release" "orgchart" {
  provider  = helm.gcp
  name      = "orgchart"
#   namespace = kubernetes_namespace.consul.metadata[0].name

#   repository = "https://helm.releases.hashicorp.com"
#   chart      = "consul"

  values = [
    "${file("config/deployment-orgchart.yaml")}"
  ]
}

