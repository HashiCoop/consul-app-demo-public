terraform {
  required_providers {
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

data "doormat_aws_credentials" "creds" {
  role_arn = "arn:aws:iam::390101570318:role/${var.TFC_WORKSPACE_NAME}"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
}

data "tfe_outputs" "cluster" {
  organization = var.TFC_ORG
  workspace = var.TFC_CLUSTER_WORKSPACE
}

output "cluster" {
    value = data.tfe_outputs.cluster.values
    sensitive = true
}

# data "aws_eks_cluster" "cluster" {
#   name = data.tfe_outputs.cluster.values.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = data.tfe_outputs.cluster.values.cluster_id
# }

# # provider "kubernetes" {
# #   host                   = data.aws_eks_cluster.cluster.endpoint
# #   token                  = data.aws_eks_cluster_auth.cluster.token
# #   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
# # }

# provider "helm" {
#   kubernetes {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   }
# }

# resource "helm_release" "consul" {
#   name       = "consul"

#   repository = "https://helm.releases.hashicorp.com"
#   chart      = "consul"

#   values = [
#     "${file("config/consul-values.yaml")}"
#   ]
# }