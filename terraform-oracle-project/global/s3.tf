# S3 bucket for storing database backups
resource \"aws_s3_bucket\" \"backup_bucket\" {
  bucket = \"-backups\"
  acl    = \"private\"
}
