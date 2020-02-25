output "url-loadbalanced" {
  value = "http://${lower(module.service_loadbalanced.alb_dns_name)}"
}
