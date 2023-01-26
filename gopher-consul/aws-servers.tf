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

data "tfe_outputs" "aws_cluster" {
  organization = var.TFC_ORG
  workspace    = var.TFC_CLUSTER_WORKSPACE
}

output "aws_cluster" {
  value = nonsensitive(data.tfe_outputs.aws_cluster.values.cluster_id)

}

data "aws_eks_cluster" "aws_cluster" {
  name = data.tfe_outputs.cluster.values.cluster_id
}

data "aws_eks_cluster_auth" "aws_cluster" {
  name = data.tfe_outputs.cluster.values.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.aws_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.aws_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.aws_cluster.certificate_authority.0.data)

  alias = "aws"
}

resource "kubernetes_namespace" "aws_consul" {
  provider = kubernetes.aws

  metadata {
    name = "consul"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }

  alias = "aws"
}

resource "helm_release" "aws_consul" {
  provider = helm.aws

  name      = "consul"
  namespace = kubernetes_namespace.aws_consul.metadata[0].name

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = [
    "${file("config/aws-consul-values.yaml")}"
  ]
}

data "kubernetes_secret" "aws_consul_bootstrap_acl_token" {
  provider = kubernetes.aws

  metadata {
    name = "consul-bootstrap-acl-token"
    namespace = helm_release.aws_consul.namespace
  }
}

data "kubernetes_service" "aws_consul_ui" {
  provider = kubernetes.aws

  metadata {
    name = "consul-ui"
    namespace = helm_release.aws_consul.namespace
  }
}

output "aws_consul_bootstrap_acl_token" {
  value = nonsensitive(data.kubernetes_secret.aws_consul_bootstrap_acl_token.data)
} 

output "aws_consul_ui_endpoint" {
  value = data.kubernetes_service.aws_consul_ui.status[0].load_balancer[0].ingress[0].hostname
}