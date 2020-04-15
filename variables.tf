variable "environment" {
  description = "Name of the environment (e.g. project-dev); will be prefixed to all resources."
  type        = string
}

variable "project" {
  description = "Project cost center / cost allocation."
  type        = string
}

variable "ecs_cluster_id" {
  description = "The id of the ECS cluster where this service will be launched."
  type        = string
}

variable "docker_repository" {
  description = "The location of the docker repository (e.g. 123456789.dkr.ecr.eu-west-1.amazonaws.com)."
  type        = string
  default     = "docker.io"
}

variable "docker_image_tag" {
  description = "The docker image version (e.g. 1.0.0 or latest)."
  type        = string
  default     = "latest"
}

variable "docker_image" {
  description = "Name of te docker image."
  type        = string
}

variable "container_memory" {
  description = "Memory to be assigned to the container."
  type        = number
  default     = 400
}

variable "container_cpu" {
  description = "CPU shares to be assigned to the container. Required for FARGATE"
  type        = string
  default     = ""
}

variable "container_ports" {
  description = "The container ports to be exposed. Optionally can include protocol (e.g. `8080`, `8080/tcp`, `8080/udp`)."
  type        = list
}

variable "networkmode" {
  description = "The network mode this container should run in. Default is bridge."
  type        = string
  default     = "bridge"
}

variable "launch_type" {
  description = "Sets launch type for service. Options are: EC2, FARGATE. Default is EC2."
  type        = string
  default     = "EC2"
}

variable "docker_environment_vars" {
  description = "A JSON formated array of tuples of docker enviroment variables."
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Name of the service to be created."
  type        = string
}

variable "docker_logging_config" {
  description = "The configuration for docker container logging"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "The number of desired tasks"
  type        = number
  default     = 1
}

variable "task_role_arn" {
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
  default     = ""
}

// ------
// ALB specific variables
// ------

variable "enable_alb" {
  description = "If true an ALB is created."
  type        = bool
  default     = false
}

variable "alb_protocol" {
  description = "Defines the ALB protocol to be used."
  default     = "HTTPS"
}

variable "alb_port" {
  description = "Defines to port for the ALB."
  type        = number
  default     = 443
}

variable "alb_certificate_arn" {
  description = "The AWS certificate ARN, required for an ALB via HTTPS. The certificate should be available in the same zone."
  type        = string
  default     = ""
}

variable "alb_timeout" {
  description = "The idle timeout in seconds of the ALB"
  type        = number
  default     = 60
}

variable "health_check_matcher" {
  description = "HTTP result code used for health validation."
  type        = string
  default     = "200-399"
}

variable "health_check_path" {
  description = "The url path part for the health check endpoint."
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  type        = string
  default     = "30"
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. Only valid for services configured to use load balancers."
  type        = string
  default     = "0"
}

variable "ecs_service_role" {
  description = "ECS service role. Required when using a load balancer when launch type is not FARGATE"
  type        = string
  default     = ""
}

variable "container_ssl_enabled" {
  description = "Set to true if container has SSL enabled. This requires that the container can handle HTTPS traffic."
  type        = bool
  default     = false
}

variable "alb_container_port" {
  description = "The container port to associate with the load balancer."
  type        = string
  default     = ""
}

variable "enable_dns" {
  description = "Enable creation of DNS record."
  type        = bool
  default     = true
}

variable "dns_zone_id" {
  description = "The ID of the DNS zone."
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "The name DNS name."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC to launch the ALB in in (e.g. vpc-66ecaa02)."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet ids to deploy the ALB."
  type        = list(string)
  default     = []
}

variable "internal_alb" {
  description = "If true this ALB is only available within the VPC, default (false) is publicly accessable (internetfacing)."
  type        = bool
  default     = false
}

variable "docker_mount_points" {
  description = "Defines the the mount point for the container."
  type        = string
  default     = ""
}

variable "volumes" {
  description = "Defines the volumes that can be mounted to a container."
  type        = list(map(string))
  default     = []
}

variable "awsvpc_service_security_groups" {
  description = "List of security groups to be attached to service running in awsvpc network mode. Required for launch type FARGATE."
  default     = []
}

variable "awsvpc_service_subnetids" {
  description = "List of subnet ids to which a service is deployed in fargate mode."
  default     = []
}

// ------
// Monitoring specific variables
// ------
variable "enable_monitoring" {
  description = "If true monitoring alerts will be created if needed."
  type        = bool
  default     = true
}

variable "monitoring_sns_topic_arn" {
  description = "ARN for the SNS topic to send alerts to."
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster where this service will be launched."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
  default     = {}
}

variable "ssl_policy" {
  description = "SSL policy applied to an SSL enabled ALB, see https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "enable_target_group_connection" {
  description = "If `true` a load balancer is created for the service which will be connected to the target group specified in `target_group_arn`. Creating a load balancer for an ecs service requires a target group with a connected load balancer. To ensure the right order of creation, provide a list of depended arns in `ecs_services_dependencies`"
  type        = bool
  default     = false
}

variable "enable_load_balanced" {
  description = "Enables load balancing for a service by creating a target group and listener rule. This option should NOT be used together with `enable_target_group_connection` delegates the creation of the target group to component that use this module."
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "Required for `enable_target_group_connection` provides the target group arn to be connected to the ecs load balancer. Ensure you provide the arns of the listeners or listeners rule conntected to the target group as `ecs_services_dependencies`."
  type        = string
  default     = ""
}

variable "listener_arn" {
  description = "Required for `enable_load_balanced`, provide the arn of the listener connected to a load balancer. By default a rule to the root of the listener will be created."
  type        = string
  default     = ""
}

variable "health_check" {
  description = "Health check for the target group, will overwrite the defaults (merged). Defaults: `protocol=HTTP or HTTPS` depends on `container_ssl`, `path=/`, `matcher=200-399` and `interval=30`."
  type        = map(string)
  default     = {}
}

variable "lb_listener_rule_condition" {
  description = "The condition for the LB listener rule which is created when `enable_load_balanced` is set."
  type        = map(string)

  default = {
    field  = "path-pattern"
    values = "/*"
  }
}

variable "ecs_services_dependencies" {
  description = "A list of arns can be provided to which the creation of the ecs service is depended."
  type        = list(string)
  default     = []
}

