# RDS instance configuration for Oracle
resource \"aws_db_instance\" \"oracle\" {
  instance_class        = var.db_instance_class
  allocated_storage     = var.allocated_storage
  engine                = \"oracle-se2\"
  engine_version        = \"19.0.0.0.ru-2020-04.rur-2020-04.r1\"
  name                  = var.db_name
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = \"default.oracle-se2-19\"
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.id
  backup_retention_period = var.backup_retention_period
  multi_az              = true
}
