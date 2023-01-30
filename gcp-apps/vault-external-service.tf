resource "consul_node" "vault" {
  name    = var.VAULT_NAME
  address = var.VAULT_EXTERNAL_ADDRESS
}

resource "consul_service" "vault" {
  name = resource.consul_node.vault.name
  node = resource.consul_node.vault.name
  port = var.VAULT_PORT

  meta = {
    external-node  = "true"
    external-probe = "false"
  }

  # check {
  #   check_id                          = "service:${var.VAULT_NAME}"
  #   name                              = "${var.VAULT_NAME}-health"
  #   status                            = "passing"
  #   http                              = "${var.VAULT_EXTERNAL_ADDRESS}:${var.VAULT_PORT}/v1/sys/health"
  #   tls_skip_verify                   = true
  #   interval                          = "10s"
  #   timeout                           = "5s"
  #   deregister_critical_service_after = "30s"
  # }
}

resource "consul_config_entry" "terminating_gateway" {
  name = "terminating-gateway"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [{ Name = var.VAULT_NAME}]
  })
}

resource "consul_config_entry" "service_defaults" {
  name = consul_service.vault.name
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
    Destination = {
      Addresses = [resource.consul_node.vault.address]
      Port      = var.VAULT_PORT
    }
  })
}