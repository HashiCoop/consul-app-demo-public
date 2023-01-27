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
        status = "passing"
        http                              = "https://vault-cluster-public-vault-fcbc1a73.d087f7bf.z1.hashicorp.cloud:8200/v1/sys/health"
        tls_skip_verify                   = true
        interval                          = "10s"
        timeout                           = "5s"
        deregister_critical_service_after = "30s"

    }
}

resource "kubernetes_manifest" "vault_term_gateway" {
  provider = kubernetes.aws
  manifest = yamldecode(file("./config/term-gw.yaml"))
}

resource "kubernetes_manifest" "vault_term_gateway" {
  provider = kubernetes.aws
  manifest = yamldecode(file("./config/service-defaults.yaml"))
}

# data "consul_acl_role" "term-gw" {
#   name = "consul-terminating-gateway-acl-role"
# }

# resource "consul_acl_policy" "vault_write" {
#     provider = consul.aws

#   name        = "vault_write"
#   rules       = <<-RULE
#     service "vault" {
#       policy = "write"
#     }
#     RULE
# }

# resource "consul_acl_token_policy_attachment" "attachment" {
#     token_id = "7d8ef1e3-9789-4dd0-fdee-aa4cd12c723e"
#     policy   = consul_acl_policy.vault_write.name
# }

# 7d8ef1e3-9789-4dd0-fdee-aa4cd12c723e

# resource "consul_acl_role" "read" {
#         provider = consul.aws

#     name = "consul-terminating-gateway-acl-role"

#     policies = [
#         consul_acl_policy.vault_write.id
#     ]
# }

# resource "consul_config_entry" "terminating_gateway" {
#   name = "vault"
#   kind = "terminating-gateway"

#   config_json = jsonencode({
#     Services = [{ Name = "billing" }]
#   })
# }