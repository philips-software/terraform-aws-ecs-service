# Terraform module for creating an ECS service.

Terraform module for creating a ECS docker service with optional load balancer and DNS record

### Notes

+ when using default monitoring metrics make sure that you specify the ecs clustername!!!!

## Example usages:

### Without Load Balancing
```

resource "aws_sns_topic" "monitoring" {
  name = "${var.environment}-monitoring"
}

module "service" {
  source = "philips-software/ecs-service/aws"
  version = "1.0.0"

  # Or via github
  # source = "github.com/philips-software/terraform-aws-ecs-service?ref=1.0.0"

  environment = "${var.environment}"
  aws_region = "${var.aws_region}"

  ecs_cluster_id = "${module.ecs-cluster.ecs_cluster_id}"
  ecs_cluster_name = "${module.ecs_cluster.name}"

  docker_image = "npalm/docker-introduction"
  container_port = "80"
  service_name = "test"

  // Monitoring settings
  monitoring_sns_topic_arn = "${aws_sns_topic.monitoring.arn}"

  // All settings below are optional
  container_cpu = "1024"
  container_memory = "2048"

  desired_count = "1"

  docker_environment_vars = <<EOF
    { "name": "VAR_X", "value": "value" }
  EOF

  // Enables logging to other targets (default is STDOUT)
  // For CloudWatch logging, make sure the awslogs-group exists
  docker_logging_config = <<EOF
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "test-logs",
        "awslogs-region": "eu-west-1"
      }
    }
  EOF

  # Define volumes for the task definition, requires a generic mount point for the ECS instances.
  volumes = [{
      name      = "logical-mount-name"
      host_path = "/path/to/dir" # e.g /efs/my-service
    }]
  }

  # Mount volumes to the container
  docker_mount_points = <<EOF
    "mountPoints": [
      {
        "readOnly": null,
        "containerPath": "/data",
        "sourceVolume": "logical-mount-name"
      }
    ]
  EOF

}

```

### With Load Balancing
```

module "service" {
  source = "philips-software/ecs-service/aws"
  version = "1.0.0"

  # Or via github
  # source = "github.com/philips-software/terraform-aws-ecs-service?ref=1.0.0"

  environment = "${var.environment}"
  aws_region = "${var.aws_region}"

  ecs_cluster_id   = "${module.ecs-cluster.ecs_cluster_id}"
  ecs_cluster_name = "${module.ecs_cluster.name}"

  docker_image = "npalm/docker-introduction"
  service_name = "test"

  // ALB specific settings
  ecs_service_role = "${var.environment}_serviceRole"
  enable_alb            = true
  internal_alb          = false // or true if it's only used in the vpc
  vpc_id                = "${var.vpc_id}"
  subnet_ids            = "${var.subnet_ids}"
  alb_certificate_arn   = "${var.certificat_arn}"
  container_ssl_enabled = false // or true if the container has SSL enabled
  container_port        = "80"

  // DNS specifc settings for the ALB
  enable_dns            = true
  dns_name              = "web-${var.environment}.${var.dns_name}" // Leave blank to disable creation of DNS record
  dns_zone_id           = "${var.dns_zone_id}"

  // Monitoring settings
  monitoring_sns_topic_arn = "${aws_sns_topic.monitoring.arn}"

  // All settings below are optional
  container_cpu = "1024"
  container_memory = "2048"

  desired_count = "1"

  docker_environment_vars = <<EOF
    { "name": "VAR_X", "value": "value" }
  EOF

  // Enables logging to other targets (default is STDOUT)
  // For CloudWatch logging, make sure the awslogs-group exists
  docker_logging_config = <<EOF
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "test-logs",
        "awslogs-region": "eu-west-1"
      }
    }
  EOF

}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_certificate_arn | The AWS certificate ARN, required for an ALB via HTTPS. The certificate should be available in the same zone. | string | `` | no |
| alb_port | Defines to port for the ALB. | string | `443` | no |
| alb_protocol | Defines the ALB protocol to be used. | string | `HTTPS` | no |
| alb_timeout | The idle timeout in seconds of the ALB | string | `60` | no |
| container_cpu | CPU shares to be assigned to the container. | string | `` | no |
| container_memory | Memory to be assigned to the container. | string | `400` | no |
| container_port | The container port to be exported to the host. | string | - | yes |
| container_ssl_enabled | Set to true if container has SSL enabled. This requires that the container can handle HTTPS traffic. | string | `false` | no |
| desired_count | The number of desired tasks | string | `1` | no |
| dns_name | The name DNS name. | string | `` | no |
| dns_zone_id | The ID of the DNS zone. | string | `` | no |
| docker_entrypoint | The entrypoint that should be used for the docker container. | list | `<list>` | no |
| docker_environment_vars | A JSON formated array of tuples of docker enviroment variables. | string | `` | no |
| docker_image | Name of te docker image. | string | - | yes |
| docker_image_tag | The docker image version (e.g. 1.0.0 or latest). | string | `latest` | no |
| docker_logging_config | The configuration for docker container logging | string | `` | no |
| docker_mount_points | Defines the the mount point for the container. | string | `` | no |
| docker_repository | The location of the docker repository (e.g. 123456789.dkr.ecr.eu-west-1.amazonaws.com). | string | `docker.io` | no |
| ecs_cluster_id | The id of the ECS cluster where this service will be launched. | string | - | yes |
| ecs_cluster_name | The name of the ECS cluster where this service will be launched. | string | - | yes |
| ecs_service_role | ECS service role. | string | `` | no |
| enable_alb | If true an ALB is created. | string | `false` | no |
| enable_dns | Enable creation of DNS record. | string | `true` | no |
| enable_monitoring | If true monitoring alerts will be created if needed. | string | `true` | no |
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | - | yes |
| health_check_grace_period_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. Only valid for services configured to use load balancers. | string | `0` | no |
| health_check_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds. | string | `30` | no |
| health_check_matcher | HTTP result code used for health validation. | string | `200-399` | no |
| health_check_path | The url path part for the health check endpoint. | string | `/` | no |
| internal_alb | If true this ALB is only available within the VPC, default (false) is publicly accessable (internetfacing). | string | `false` | no |
| monitoring_sns_topic_arn | ARN for the SNS topic to send alerts to. | string | `` | no |
| project | Project cost center / cost allocation. | string | - | yes |
| service_name | Name of the service to be created. | string | - | yes |
| ssl_policy | SSL policy applied to an SSL enabled ALB, see https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html | string | `ELBSecurityPolicy-TLS-1-2-2017-01` | no |
| subnet_ids | Comma separated list with subnet itd. | string | `` | no |
| tags | A map of tags to add to the resources | map | `<map>` | no |
| task_role_arn | The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services. | string | `` | no |
| volumes | Defines the volumes that can be mounted to a container. | list | `<list>` | no |
| vpc_id | The VPC to launch the ALB in in (e.g. vpc-66ecaa02). | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name | DNS address of the load balancer, if created. |
| alb_route53_dns_name | Route 53 DNS name, if created. |
| aws_alb_target_group_arn | ARN of the loadbalancer target group. |

## Philips Forest

This module is part of the Philips Forest.

```
                                                     ___                   _
                                                    / __\__  _ __ ___  ___| |_
                                                   / _\/ _ \| '__/ _ \/ __| __|
                                                  / / | (_) | | |  __/\__ \ |_
                                                  \/   \___/|_|  \___||___/\__|  

                                                                 Infrastructure
```

Talk to the forestkeepers in the `forest`-channel on Slack.

[![Slack](https://philips-software-slackin.now.sh/badge.svg)](https://philips-software-slackin.now.sh)
