# PostgreSQL RDS
resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a1.id, aws_subnet.private_a2.id,  aws_subnet.private_b.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  db_name              = "yoram_carmel_db"
  username             = "admin"
  password             = "password"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  publicly_accessible  = false
  skip_final_snapshot  = true
}

# PostgreSQL Provider Configuration
provider "postgresql" {
  host     = aws_db_instance.postgres.address
  port     = aws_db_instance.postgres.port
  database = "postgres"  # Connect to the default database to create the user and assign ownership
  username = "admin"
  password = "password"
}

# Creates status-page user and log into it
resource "postgresql_role" "status_page_user" {
  name     = "status-page"
  password = "status-page"
  login    = true
}

# Grant ownership of the database to the status-page user
resource "postgresql_database" "yoram_carmel_db" {
  name  = aws_db_instance.postgres.dbname
  owner = postgresql_role.status_page_user.name
}

# Grant privileges
resource "postgresql_grant" "status_page_db_grant" {
  database    = postgresql_database.database.name
  role        = postgresql_role.status_page_user.name
  privileges  = ["ALL"]
}
