variable "CONSUL_NAME" {
    type = string
    default = "consul"
}

variable "CONSUL_VALUES" {
    type = list(string)
}

variable "CONSUL_NAMESPACE" {
    type = string
    default = "consul"
}

variable "KUBERNETES_AUTH" {
    type = object({
        host = string
        token = string
        cluster_ca_certificate = string
    })
}