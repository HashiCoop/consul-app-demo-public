output "consul_bootstrap_acl_token" {
  value = nonsensitive(data.kubernetes_secret.consul_bootstrap_acl_token.data.token)
} 

output "consul_ui_endpoint" {
  value = data.kubernetes_service.consul_ui.status[0].load_balancer[0].ingress[0]
}

output "dns" {
  value = data.kubernetes_service.consul_dns.spec[0]
}