# VPC configuration
resource \"aws_vpc\" \"main\" {
  cidr_block = \"10.0.0.0/16\"
}

resource \"aws_subnet\" \"subnet\" {
  vpc_id     = aws_vpc.main.id
  cidr_block = \"10.0.1.0/24\"
}

resource \"aws_security_group\" \"rds_sg\" {
  name_prefix = \"rds_sg\"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = \"tcp\"
    cidr_blocks = [\"0.0.0.0/0\"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = \"-1\"
    cidr_blocks = [\"0.0.0.0/0\"]
  }
}

resource \"aws_db_subnet_group\" \"main\" {
  name       = \"main-subnet-group\"
  subnet_ids = [aws_subnet.subnet.id]
}
