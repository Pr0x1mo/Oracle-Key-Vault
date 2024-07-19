# CloudWatch monitoring configuration
resource \"aws_cloudwatch_log_group\" \"rds_log_group\" {
  name              = \"/aws/rds/instance/\"
  retention_in_days = 7
}

resource \"aws_cloudwatch_metric_alarm\" \"cpu_alarm\" {
  alarm_name          = \"high-cpu\"
  comparison_operator = \"GreaterThanThreshold\"
  evaluation_periods  = 2
  metric_name         = \"CPUUtilization\"
  namespace           = \"AWS/RDS\"
  period              = 300
  statistic           = \"Average\"
  threshold           = 80
  alarm_description   = \"This metric monitors RDS CPU utilization\"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.oracle.id
  }
  alarm_actions = [var.alarm_action]
}
