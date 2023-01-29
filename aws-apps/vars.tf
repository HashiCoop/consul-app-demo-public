variable "VAULT_NAME" {
    type = string
    default = "vault"
}

variable "VAULT_EXTERNAL_ADDRESS" {
    type = string
    default = "https://vault-cluster-public-vault-fcbc1a73.d087f7bf.z1.hashicorp.cloud"
}

variable "VAULT_PORT" {
    type = number
    default = 8200
}

variable "VAULT_UPSTREAM_DC" {
    type = string
    default = "gcp-us-central1-c"
}