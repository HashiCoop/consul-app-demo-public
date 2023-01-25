output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
    value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
    value = nonsensitive(module.eks.cluster_id)
    sensitive = false
}

