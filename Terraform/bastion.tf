# Attach IAM Role to Bastion Instance for Session Manager
resource "aws_iam_role" "ssm_role" {
  name               = "BastionSSMRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    }
  }
}
EOF
}

# Attach SSM policies
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

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

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "BastionSSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
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
