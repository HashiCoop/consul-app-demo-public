terraform {
  required_providers {
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.0"
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

locals {
    tags = {
        Proj = "gopher-app"
        Owner = "cmelgreen"
    }
}

data "tfe_outputs" "vpc" {
  organization = var.TFC_ORG
  workspace = var.TFC_NETWORK_WORKSPACE
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = "${var.TFC_WORKSPACE_NAME}-v2"
  cluster_version = "1.23"

  vpc_id     = data.tfe_outputs.vpc.values.vpc.vpc_id
  subnet_ids =  data.tfe_outputs.vpc.values.vpc.private_subnets
  
  node_security_group_tags = {
    "kubernetes.io/cluster/${var.TFC_WORKSPACE_NAME}-v2" = null
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }
  
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

#      vpc_security_group_ids = [
#        aws_security_group.node_group_one.id
#      ]
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

    }
  }

  manage_aws_auth_configmap = true

  ### THESE ARE CAUSING THE PERMISSION ERRORS! AUTOMATE!!!!
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::390101570318:role/aws_cooper_test-developer"
      username = "admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::390101570318:role/gopher-consul"
      username = "consul"
      groups   = ["system:masters"]
    },
  ]
}

#resource "aws_security_group" "node_group_one" {
#  name_prefix = "node_group_one"
#  vpc_id      = data.tfe_outputs.vpc.values.vpc_id
#
#  ingress {
#    from_port = 22
#    to_port   = 22
#    protocol  = "tcp"
#
#    cidr_blocks = [
#      "10.0.0.0/8",
#    ]
#  }
#}

#resource "aws_security_group" "node_group_two" {
#  name_prefix = "node_group_two"
#  vpc_id      = data.tfe_outputs.vpc.values.vpc_id
#
#  ingress {
#    from_port = 22
#    to_port   = 22
#    protocol  = "tcp"
#
#    cidr_blocks = [
#      "192.168.0.0/16",
#    ]
#  }
#}