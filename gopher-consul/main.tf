data "tfe_outputs" "cluster" {
  organization = var.TFC_ORG
  workspace = var.TFC_CLUSTER_WORKSPACE
}

data "aws_eks_cluster" "cluster" {
  name = data.tfe_outputs.cluster.values.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.tfe_outputs.cluster.values.cluster_id
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
# }

provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

resource "helm_release" "consul" {
  name       = "consul"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = [
    "${file("config/consul-values.yaml")}"
  ]
}