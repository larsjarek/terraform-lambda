# Terraform lambda

## Overview

Terraform code for simple lambda with sqs trigger.

## Installation

[Terraform](https://www.terraform.io/) v1+ required.

Create a .zip file with lambda code.

```sh
cd example
zip example.zip index.js
```

Deploy Terraform infrastructure.

```sh
cd terraform
terraform init --backend-config=./config/dev/config.remote
terraform apply --var-file=./config/dev/config.tfvars
```