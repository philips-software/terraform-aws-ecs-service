output "blog_url" {
  value = "${lower(module.service.alb_dns_name)}"
}
