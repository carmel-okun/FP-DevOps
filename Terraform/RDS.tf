# PostgreSQL RDS
resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a1.id, aws_subnet.private_a2.id,  aws_subnet.private_b.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "14.9"
  instance_class       = "db.t3.micro"
  dbname               = "yoram-carmel-database"
  username             = "admin"
  password             = "password"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  publicly_accessible  = false
  skip_final_snapshot  = true
}
