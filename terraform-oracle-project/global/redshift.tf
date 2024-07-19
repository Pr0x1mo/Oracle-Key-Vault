# Redshift cluster configuration for data warehousing
resource \"aws_redshift_cluster\" \"main\" {
  cluster_identifier = \"redshift-cluster\"
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password
  node_type          = \"dc2.large\"
  cluster_type       = \"single-node\"
}
