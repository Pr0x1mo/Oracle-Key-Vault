# Data Guard configuration
resource \"aws_rds_cluster\" \"dataguard_cluster\" {
  cluster_identifier = \"dataguard-cluster\"
  engine             = \"aurora\"
  engine_version     = \"5.6.10a\"
  master_username    = var.db_username
  master_password    = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
