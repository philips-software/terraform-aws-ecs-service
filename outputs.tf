output "alb_arn" {
  description = "Load Balancer ARN."
  value       = "${local.lb_arn}"
}

output "alb_dns_name" {
  description = "DNS address of the load balancer, if created."
  value       = "${local.lb_dns_name}"
}

output "aws_alb_target_group_arn" {
  description = "ARN of the loadbalancer target group."
  value       = "${element(concat(aws_alb_target_group.target_group.*.arn, list("")), 0)}"
}

output "alb_route53_dns_name" {
  description = "Route 53 DNS name, if created."
  value       = "${element(concat(aws_route53_record.dns_record.*.name, list("")), 0)}"
}
