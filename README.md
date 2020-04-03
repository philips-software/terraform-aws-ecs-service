# Terraform module for creating an ECS service.

Terraform module for creating a ECS docker service with optional load balancer and DNS record. Has support for both EC2 and Fargate.

## Terraform version

- Terraform 0.12: Pin module to `~> 2+`, submit pull request to branch `develop`
- Terraform 0.11: Pin module to `~> 1.x`, submit pull request to branch `terrafomr011`


### Deprecated
- `enable_alb` : Since release 1.3.0 the load balancer can be controlled externally, load balancers can be create via a separate module. In the next major release the embedded alb in this module will be removed.


### Notes

+ when using default monitoring metrics make sure that you specify the ecs clustername!!!!
+ For Fargate, check the supported CPU/Memory configurations: https://aws.amazon.com/fargate/pricing/

## Example usages:
Please see the examples:
- [default](./examples/default) - shows basic usages such as: ALB, EFS mounts.
- [load-balanced](./examples/load-balanced) - shows several scenario's for using load balancers attached to an ECS service.
- [fargate](./examples/fargate) - shows several scenario's for using a Fargate ECS service.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb\_certificate\_arn | The AWS certificate ARN, required for an ALB via HTTPS. The certificate should be available in the same zone. | string | `""` | no |
| alb\_port | Defines to port for the ALB. | number | `"443"` | no |
| alb\_protocol | Defines the ALB protocol to be used. | string | `"HTTPS"` | no |
| alb\_timeout | The idle timeout in seconds of the ALB | number | `"60"` | no |
| awsvpc\_service\_security\_groups | List of security groups to be attached to service running in awsvpc network mode. Required for launch type FARGATE. | list | `<list>` | no |
| awsvpc\_service\_subnetids | List of subnet ids to which a service is deployed in fargate mode. | list | `<list>` | no |
| container\_cpu | CPU shares to be assigned to the container. | string | `""` | no |
| container\_memory | Memory to be assigned to the container. | number | `"400"` | no |
| container\_port | The container port to be exported to the host. | string | n/a | yes |
| container\_ssl\_enabled | Set to true if container has SSL enabled. This requires that the container can handle HTTPS traffic. | bool | `"false"` | no |
| desired\_count | The number of desired tasks | number | `"1"` | no |
| dns\_name | The name DNS name. | string | `""` | no |
| dns\_zone\_id | The ID of the DNS zone. | string | `""` | no |
| docker\_environment\_vars | A JSON formated array of tuples of docker enviroment variables. | string | `""` | no |
| docker\_image | Name of te docker image. | string | n/a | yes |
| docker\_image\_tag | The docker image version (e.g. 1.0.0 or latest). | string | `"latest"` | no |
| docker\_logging\_config | The configuration for docker container logging | string | `""` | no |
| docker\_mount\_points | Defines the the mount point for the container. | string | `""` | no |
| docker\_repository | The location of the docker repository (e.g. 123456789.dkr.ecr.eu-west-1.amazonaws.com). | string | `"docker.io"` | no |
| ecs\_cluster\_id | The id of the ECS cluster where this service will be launched. | string | n/a | yes |
| ecs\_cluster\_name | The name of the ECS cluster where this service will be launched. | string | n/a | yes |
| ecs\_service\_role | ECS service role. | string | `""` | no |
| ecs\_services\_dependencies | A list of arns can be provided to which the creation of the ecs service is depended. | list(string) | `<list>` | no |
| enable\_alb | If true an ALB is created. | bool | `"false"` | no |
| enable\_dns | Enable creation of DNS record. | bool | `"true"` | no |
| enable\_load\_balanced | Enables load balancing for a service by creating a target group and listener rule. This option should NOT be used together with `enable_target_group_connection` delegates the creation of the target group to component that use this module. | bool | `"false"` | no |
| enable\_monitoring | If true monitoring alerts will be created if needed. | bool | `"true"` | no |
| enable\_target\_group\_connection | If `true` a load balancer is created for the service which will be connected to the target group specified in `target_group_arn`. Creating a load balancer for an ecs service requires a target group with a connected load balancer. To ensure the right order of creation, provide a list of depended arns in `ecs_services_dependencies` | bool | `"false"` | no |
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | n/a | yes |
| health\_check | Health check for the target group, will overwrite the defaults (merged). Defaults: `protocol=HTTP or HTTPS` depends on `container_ssl`, `path=/`, `matcher=200-399` and `interval=30`. | map(string) | `<map>` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. Only valid for services configured to use load balancers. | string | `"0"` | no |
| health\_check\_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds. | string | `"30"` | no |
| health\_check\_matcher | HTTP result code used for health validation. | string | `"200-399"` | no |
| health\_check\_path | The url path part for the health check endpoint. | string | `"/"` | no |
| internal\_alb | If true this ALB is only available within the VPC, default (false) is publicly accessable (internetfacing). | bool | `"false"` | no |
| launch\_type | Sets launch type for service. Options are: EC2, FARGATE. Default is EC2. | string | `"EC2"` | no |
| lb\_listener\_rule\_condition | The condition for the LB listener rule which is created when `enable_load_balanced` is set. | map(string) | `<map>` | no |
| listener\_arn | Required for `enable_load_balanced`, provide the arn of the listener connected to a load balancer. By default a rule to the root of the listener will be created. | string | `""` | no |
| monitoring\_sns\_topic\_arn | ARN for the SNS topic to send alerts to. | string | `""` | no |
| project | Project cost center / cost allocation. | string | n/a | yes |
| service\_name | Name of the service to be created. | string | n/a | yes |
| ssl\_policy | SSL policy applied to an SSL enabled ALB, see https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html | string | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| subnet\_ids | List of subnet ids to deploy the ALB. | list(string) | `<list>` | no |
| tags | A map of tags to add to the resources | map(string) | `<map>` | no |
| target\_group\_arn | Required for `enable_target_group_connection` provides the target group arn to be connected to the ecs load balancer. Ensure you provide the arns of the listeners or listeners rule conntected to the target group as `ecs_services_dependencies`. | string | `""` | no |
| task\_role\_arn | The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services. | string | `""` | no |
| volumes | Defines the volumes that can be mounted to a container. | list(map(string)) | `<list>` | no |
| efs_volumes | Defines the EFS volumes that can be mounted to a container. | list(map(string)) | `<list>` | no |
| vpc\_id | The VPC to launch the ALB in in (e.g. vpc-66ecaa02). | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_dns\_name | DNS address of the load balancer, if created. |
| alb\_route53\_dns\_name | Route 53 DNS name, if created. |
| aws\_alb\_target\_group\_arn | ARN of the loadbalancer target group. |

## Automated checks
Currently the automated checks are limited. In CI the following checks are done for the root and each example.
- lint: `terraform validate` and `terraform fmt`
- basic init / get check: `terraform init -get -backend=false -input=false`

## Generation variable documentation
A markdown table for variables can be generated as follow. Generation requires awk and terraform-docs installed.

```
 .ci/bin/terraform-docs.sh markdown
```

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
