locals {
  service_name = "example-lambda"

  tags = {
    Name        = local.service_name
    Environment = var.env
    GitRepo     = "larsjarek/terraform-lambda"
    ManagedBy   = "terraform"
  }

  lambda_runtime = "nodejs14.x"
  lambda_timeout = 3
  log_retention  = 3
}