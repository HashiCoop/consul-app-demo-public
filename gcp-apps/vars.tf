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
  default = "10.116.15.99"
    # default = "google.com"
}

variable "VAULT_PORT" {
  type    = number
  default = 80
}