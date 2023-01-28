data "tfe_outputs" "cluster" {
  organization = var.TFC_ORG
  workspace    = var.TFC_CLUSTER_WORKSPACE
}

data "aws_eks_cluster" "cluster" {
  name = data.tfe_outputs.cluster.values.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.tfe_outputs.cluster.values.cluster_id
}

module "aws_consul" {
  source = "./modules/consul-k8s-cluster"

  CONSUL_VALUES = ["config/aws-consul-values.yaml"]
  
  KUBERNETES_AUTH = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

output "aws_consul_bootstrap_acl_token" {
  value = nonsensitive(module.aws_consul.consul_bootstrap_acl_token)
} 

output "aws_consul_ui_endpoint" {
  value = module.aws_consul.consul_ui_endpoint.hostname
}