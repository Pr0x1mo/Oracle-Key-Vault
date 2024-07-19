# Variables for Terraform configuration
variable \"region\" {
  description = \"AWS region\"
  type        = string
  default     = \"us-west-2\"
}

variable \"db_instance_class\" {
  description = \"Database instance class\"
  type        = string
  default     = \"db.t3.medium\"
}

variable \"allocated_storage\" {
  description = \"The size of the database (Gb)\"
  type        = number
  default     = 20
}

variable \"db_name\" {
  description = \"Database name\"
  type        = string
}

variable \"db_username\" {
  description = \"Database admin username\"
  type        = string
}

variable \"db_password\" {
  description = \"Database admin password\"
  type        = string
}

variable \"backup_retention_period\" {
  description = \"The number of days to retain backups\"
  type        = number
  default     = 7
}

variable \"alarm_action\" {
  description = \"ARN of the action to take when an alarm state is triggered\"
  type        = string
}

variable \"kms_key_arn\" {
  description = \"KMS key ARN for encryption\"
  type        = string
}
