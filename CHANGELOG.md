# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

## 1.3.0 - 2018-12-20
- Added option to control the load balancer externally by setting the target group.
- Added option to connect to existing load balancer by setting the listener.
- Changed: vpc data resource is only used when enable_alb is set.

## 1.2.1 - 2018-11-20
- Changed: #14 https://github.com/philips-software/terraform-aws-ecs-service/issues/14

## 1.2.0 - 2018-11-15
- Changed: SSL policy is configurable, default upgraded to: ELBSecurityPolicy-TLS-1-2-2017-01. To keep the old policy in place set the variable `ssl_policy` to: `ELBSecurityPolicy-2015-05 `
- Changed: Removed egres from alb ecurity group, limit port to alb port only.

## 1.1.0 - 2018-12-12
- Make the idle timeout of the ALB configurable
- Added task_role_arn so a task can be secured using a role to restrict access to specific resources

## 1.0.1 - 2018-07-02
https://github.com/philips-software/terraform-aws-ecs-service/tags/1.0.1
- Add example

## 1.0.0 - 2018-07-02
https://github.com/philips-software/terraform-aws-ecs-service/tags/1.0.0
- Slack badge in documentation
- Add default lifecycle for targetgroups
- Add default monitoring capabilities for ECS Services (default enabled)
- Add Health Check Grace Period for services that need more time to start
- Add Health Check Interval parameter for configuring how often a health check is executed
- Limit cidr for internal lb to vpc cidr
- Add output for Route53 dns record
- Updated documentation
- Refactor outputs to support terraform 0.11
- Add support to mount volumes

[Unreleased]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.2.1...HEAD
[1.2.1]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.0.0...1.0.1
