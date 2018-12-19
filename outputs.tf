output "alb_dns_name" {
  description = "DNS address of the load balancer, if created."
  value       = "${element(concat(aws_alb.alb.*.dns_name, list("")), 0)}"
}

output "aws_alb_target_group_arn" {
  description = "ARN of the loadbalancer target group."
  value       = "${element(concat(aws_alb_target_group.target_group.*.arn, list("")), 0)}"
}

output "alb_route53_dns_name" {
  description = "Route 53 DNS name, if created."
  value       = "${element(concat(aws_route53_record.dns_record.*.name, list("")), 0)}"
}
