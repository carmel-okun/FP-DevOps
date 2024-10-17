# PostgreSQL RDS
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "carmel-yoram-rds-subnet-group"
  subnet_ids = [aws_subnet.private_a1.id, aws_subnet.private_a2.id, aws_subnet.private_b.id]
}

# yoram-carmel-postgres-db  
# RDS instance definition
resource "aws_db_instance" "rds" {
	# identifier 							= "yoram-carmel-postgres-db"
  allocated_storage      	= 20
  engine                 	= "postgres"
  engine_version         	= "16.3"
  instance_class         	= "db.t3.micro"
  db_name                	= "postgres"
  username               	= "status_page"
  password               	= "password"
  vpc_security_group_ids 	= [aws_security_group.rds_sg.id]
  db_subnet_group_name   	= aws_db_subnet_group.rds_subnet.id
  publicly_accessible    	= false
  storage_type           	= "gp3"

  # Automatically create a final snapshot when destroying
	skip_final_snapshot    = false
  final_snapshot_identifier = "carmel-yoram-final-snapshot"

	tags = {
    Name = "yoram-carmel-postgres-db"
  }
}

# Data source to fetch the existing manual snapshot (if any)
data "aws_db_snapshot" "existing_snapshot" {
  db_instance_identifier = aws_db_instance.rds.id
  snapshot_type          = "manual"
  most_recent            = true
}

# Null resource to delete the existing snapshot (if it exists)
resource "null_resource" "delete_existing_snapshot" {
  provisioner "local-exec" {
    command = <<EOT
      if aws rds describe-db-snapshots --db-snapshot-identifier ${data.aws_db_snapshot.existing_snapshot.id}; then
        aws rds delete-db-snapshot --db-snapshot-identifier ${data.aws_db_snapshot.existing_snapshot.id};
      fi
    EOT
  }

  # Only run after the data source is populated (applied after instance is available)
  triggers = {
    snapshot_id = data.aws_db_snapshot.existing_snapshot.id
  }
}

# Create a new snapshot with the same identifier (overriding the old one)
resource "aws_db_snapshot" "rds_snapshot" {
  db_instance_identifier 		= aws_db_instance.rds.id
  db_snapshot_identifier    = "carmel-yoram-rds-snapshot"

  # Ensure the previous snapshot is deleted first
  depends_on = [null_resource.delete_existing_snapshot]
}