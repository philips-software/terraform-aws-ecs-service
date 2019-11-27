output "url-default" {
  value = "http://${lower(module.service.alb_dns_name)}"
}
