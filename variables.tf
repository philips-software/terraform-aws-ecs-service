variable "environment" {
  description = "Name of the environment (e.g. project-dev); will be prefixed to all resources."
  type        = "string"
}

variable "project" {
  description = "Project cost center / cost allocation."
  type        = "string"
}

variable "ecs_cluster_id" {
  type        = "string"
  description = "The id of the ECS cluster where this service will be launched."
}

variable "docker_repository" {
  type        = "string"
  default     = "docker.io"
  description = "The location of the docker repository (e.g. 123456789.dkr.ecr.eu-west-1.amazonaws.com)."
}

variable "docker_image_tag" {
  type        = "string"
  default     = "latest"
  description = "The docker image version (e.g. 1.0.0 or latest)."
}

variable "docker_image" {
  type        = "string"
  description = "Name of te docker image."
}

variable "container_memory" {
  default     = "400"
  type        = "string"
  description = "Memory to be assigned to the container."
}

variable "container_cpu" {
  default     = ""
  type        = "string"
  description = "CPU shares to be assigned to the container."
}

variable "docker_environment_vars" {
  description = "A JSON formated array of tuples of docker enviroment variables."
  type        = "string"
  default     = ""
}

variable "service_name" {
  description = "Name of the service to be created."
  type        = "string"
}

variable "docker_logging_config" {
  type        = "string"
  default     = ""
  description = "The configuration for docker container logging"
}

variable "desired_count" {
  type        = "string"
  default     = "1"
  description = "The number of desired tasks"
}

variable "task_role_arn" {
  type        = "string"
  default     = ""
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}

// ------
// ALB specific variables
// ------

variable "enable_alb" {
  description = "If true an ALB is created."
  default     = false
}

variable "alb_protocol" {
  description = "Defines the ALB protocol to be used."
  default     = "HTTPS"
}

variable "alb_port" {
  description = "Defines to port for the ALB."
  default     = 443
}

variable "alb_certificate_arn" {
  description = "The AWS certificate ARN, required for an ALB via HTTPS. The certificate should be available in the same zone."
  type        = "string"
  default     = ""
}

variable "alb_timeout" {
  description = "The idle timeout in seconds of the ALB"
  default     = 60
}

variable "health_check_matcher" {
  description = "HTTP result code used for health validation."
  default     = "200-399"
}

variable "health_check_path" {
  description = "The url path part for the health check endpoint."
  default     = "/"
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  default     = "30"
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. Only valid for services configured to use load balancers."
  default     = "0"
}

variable "ecs_service_role" {
  description = "ECS service role."
  type        = "string"
  default     = ""
}

variable "container_ssl_enabled" {
  default     = false
  description = "Set to true if container has SSL enabled. This requires that the container can handle HTTPS traffic."
}

variable "container_port" {
  description = "The container port to be exported to the host."
  type        = "string"
}

variable "enable_dns" {
  description = "Enable creation of DNS record."
  default     = true
}

variable "dns_zone_id" {
  type        = "string"
  description = "The ID of the DNS zone."
  default     = ""
}

variable "dns_name" {
  type        = "string"
  description = "The name DNS name."
  default     = ""
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC to launch the ALB in in (e.g. vpc-66ecaa02)."
  default     = ""
}

variable "subnet_ids" {
  type        = "string"
  description = "Comma separated list with subnet itd."
  default     = ""
}

variable "internal_alb" {
  description = "If true this ALB is only available within the VPC, default (false) is publicly accessable (internetfacing)."
  default     = false
}

variable "docker_mount_points" {
  description = "Defines the the mount point for the container."
  type        = "string"
  default     = ""
}

variable "volumes" {
  description = "Defines the volumes that can be mounted to a container."
  type        = "list"
  default     = []
}

// ------
// Monitoring specific variables
// ------
variable "enable_monitoring" {
  description = "If true monitoring alerts will be created if needed."
  default     = true
}

variable "monitoring_sns_topic_arn" {
  type        = "string"
  description = "ARN for the SNS topic to send alerts to."
  default     = ""
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "The name of the ECS cluster where this service will be launched."
}

variable "tags" {
  type        = "map"
  description = "A map of tags to add to the resources"
  default     = {}
}

variable "ssl_policy" {
  type        = "string"
  description = "SSL policy applied to an SSL enabled ALB, see https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html"
  default     = "ELBSecurityPolicy-2015-05"
}
