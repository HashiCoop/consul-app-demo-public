# # resource "kubernetes_namespace" "gcp_vault" {
# #     provider = kubernetes.gcp
# #   metadata {
# #     name = "orgchart"
# #   }
# # }

# resource "helm_release" "vault" {
#   provider  = helm.gcp
#   name      = "vault"
#   namespace = "consul"

#   repository = "https://helm.releases.hashicorp.com"
#   chart      = "vault"

#   values = [
#     file("config/deployment-orgchart.yaml")
#   ]
# }

# resource "kubernetes_service_account" "example" {
#     provider = kubernetes.gcp
#   metadata {
#     name = "internal-app"
#     namespace = "consul"
#   }
# }

# resource "kubernetes_manifest" "orgchart" {
#     provider = kubernetes.gcp
#   manifest = yamldecode(file("./config/devwebapp-service.yaml"))
# }

# # resource "kubernetes_manifest" "orgchart-service" {
# #     provider = kubernetes.gcp
# #   manifest = yamldecode(file("./config/devwebapp.yaml"))
# # }

# resource "kubernetes_manifest" "orgchart-deployment" {
#     provider = kubernetes.gcp
#   manifest = yamldecode(file("./config/devwebapp.yaml"))
# }


