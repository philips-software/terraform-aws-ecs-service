# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased
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

[Unreleased]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.0.1...HEAD
[1.0.1]: https://github.com/philips-software/terraform-aws-ecs-service/compare/1.0.0...1.0.1
