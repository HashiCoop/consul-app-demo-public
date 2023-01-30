variable "TFC_ORG" {
  type    = string
  default = "hashicoop"
}

variable "TFC_CONSUL_WORKSPACE" {
  type    = string
  default = "gopher-consul"
}

variable "VAULT_NAME" {
  type    = string
  default = "vault"
}

variable "VAULT_EXTERNAL_ADDRESS" {
  type    = string
#   default = "vault-cluster-public-vault-fcbc1a73.d087f7bf.z1.hashicorp.cloud"
    default = "google.com"
}

variable "VAULT_PORT" {
  type    = number
  default = 80
}