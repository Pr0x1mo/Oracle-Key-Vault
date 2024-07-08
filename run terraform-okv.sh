#!/bin/bash

# Navigate to your Terraform project directory
cd /path/to/terraform-okv  # Replace with your actual Terraform project directory

# Initialize Terraform
terraform init

# Validate Terraform configuration (optional)
terraform validate

# Plan Terraform changes
terraform plan

# Apply Terraform changes
terraform apply

# Optional: Terraform apply with auto-approval (comment out if not needed)
# terraform apply -auto-approve

# Optional: Terraform destroy (uncomment and use with caution to destroy resources)
# terraform destroy
