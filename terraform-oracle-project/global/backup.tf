# Backup configuration
resource \"aws_backup_vault\" \"main\" {
  name        = \"main-backup-vault\"
  kms_key_arn = var.kms_key_arn
}

resource \"aws_backup_plan\" \"daily_backup\" {
  name = \"daily-backup-plan\"

  rule {
    rule_name         = \"daily-backup\"
    target_vault_name = aws_backup_vault.main.name
    schedule          = \"cron(0 2 * * ? *)\"
    lifecycle {
      delete_after = 30
    }
  }
}
