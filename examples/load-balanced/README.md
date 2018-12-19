# Test ECS service

This examples shows the usages of the module for the options: `enable_load_balanced` and `enable_target_group_connection`.

## service-lb-ssl
Shows how to use the option `enable_load_balanced` with a Route53 DNS and SSL. Requires to provide a DNS name as variable.

## service-path
Shows how to use the option `enable_load_balanced` with a custom path.

## service-tg
Shows how to use the option `enable_target_group_connection` to completly control the loadbalancer outside the service module.


## Prerequisites for running the example
Terraform is managed via the tool `tfenv`. Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version`

## Generate ssh and init terraform

```
source ./generate-ssh-key.sh
terraform init

```

## Plan the changes and inspect

```
terraform plan
```

## Create the environment.

```
terraform apply
```

Once done you can test the service via the URL on the console. It can take a few minutes before the service is available


## Cleanup

```
terraform destroy
```
