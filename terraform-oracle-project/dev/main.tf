# Main Terraform configuration for dev environment
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-west-2"
  }
}

module "network" {
  source  = "../global"
  vpc_cidr = "10.0.0.0/16"
}

module "db" {
  source = "../global"
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}
