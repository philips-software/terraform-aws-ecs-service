# Test ECS service

This directory contains a test setup for an ECS service on Fargate.

* service loadbalanced: ALB via HTTP
* service default: HTTP without ALB

## Prerequisites for running the example

Terraform is managed via the tool `tfenv` . Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version` 

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

