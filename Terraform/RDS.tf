terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.0" # Specify the version you want to use
    }
  }
}

# PostgreSQL RDS
resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a1.id, aws_subnet.private_a2.id, aws_subnet.private_b.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  db_name                = "status_page"
  username               = "status_page"
  password               = "password"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_type           = "gp3"
}

# PostgreSQL Provider Configuration
# provider "postgresql" {
#   host     = aws_db_instance.postgres.address
#   port     = aws_db_instance.postgres.port
#   database = aws_db_instance.postgres.db_name
#   username = aws_db_instance.postgres.username
#   password = aws_db_instance.postgres.password
#   sslmode  = "require"
# }
