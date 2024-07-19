# Outputs for Terraform
output \"rds_endpoint\" {
  description = \"The endpoint of the RDS instance\"
  value       = aws_db_instance.oracle.endpoint
}

output \"redshift_endpoint\" {
  description = \"The endpoint of the Redshift cluster\"
  value       = aws_redshift_cluster.main.endpoint
}
