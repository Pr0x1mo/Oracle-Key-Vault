# Encryption configuration
resource \"aws_kms_key\" \"rds_encryption\" {
  description = \"KMS key for RDS encryption\"
}

resource \"aws_rds_cluster\" \"encrypted_cluster\" {
  cluster_identifier       = \"encrypted-cluster\"
  engine                   = \"aurora\"
  master_username          = var.db_username
  master_password          = var.db_password
  db_subnet_group_name     = aws_db_subnet_group.main.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  kms_key_id               = aws_kms_key.rds_encryption.arn
  storage_encrypted        = true
}
