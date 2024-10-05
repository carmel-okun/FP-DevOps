resource "aws_instance" "bastion" {
  ami           = "ami-0866a3c8686eaeeba"  # Ubuntu linux t2.micro
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "YoramBastionHost"
  }

  # Security group for SSH access
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
}

# Security Group for the Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "yoram_bastion_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Your public IP - for now all can access :D (later ip = x.x.x.x/32)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
