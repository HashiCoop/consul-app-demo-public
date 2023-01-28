variable "CONSUL_VALUES" {
    type = lsit(string)
}

variable "CONSUL_NAMESPACE" {
    type = string
    default = "consul"
}

variable "K8S_AUTH" {
    type = object({
        host = string
        token = string
        cluster_ca_certificate = string
    })
}