resource "consul_node" "vault" {
    provider = consul.aws
  name    = "vault"
  address = "https://vault-cluster-public-vault-fcbc1a73.d087f7bf.z1.hashicorp.cloud"
}

resource "consul_service" "vault" {
    provider = consul.aws

    name = "vault"
    node = resource.consul_node.vault.name
    port = 8200
    meta = {
        external-node = "true"
        external-probe = "false"
    }

    tags = ["v1"]

    check {
        check_id                          = "service:vault_api"
        name                              = "vault health"
        status                            = "passing"
        http                              = "https://vault-cluster-public-vault-fcbc1a73.d087f7bf.z1.hashicorp.cloud:8200/v1/sys/health"
        tls_skip_verify                   = false
        interval                          = "10s"
        timeout                           = "5s"
        deregister_critical_service_after = "30s"
    }
}