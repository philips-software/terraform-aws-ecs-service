output "url-default" {
  value = "http://${lower(module.service.alb_dns_name)}"
}


output "url-feature" {
  value = "http://${lower(module.service-features.alb_dns_name)}"
}

