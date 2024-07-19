# PL/SQL execution using CodeBuild
resource \"aws_codebuild_project\" \"plsql_execution\" {
  name          = \"plsql-execution\"
  source {
    type      = \"S3\"
    location  = \"s3://path-to-your-plsql-scripts\"
  }
  environment {
    compute_type                = \"BUILD_GENERAL1_SMALL\"
    image                       = \"aws/codebuild/standard:4.0\"
    type                        = \"LINUX_CONTAINER\"
    environment_variables {
      name  = \"DB_USER\"
      value = var.db_username
    }
    environment_variables {
      name  = \"DB_PASS\"
      value = var.db_password
    }
  }
  buildspec = <<-EOF
    version: 0.2
    phases:
      install:
        runtime-versions:
          sqlplus: 12.2.0.1
      build:
        commands:
          - echo \"Running PL/SQL scripts\"
          - sqlplus \/\@your-db-endpoint @your-script.sql
    EOF
}
