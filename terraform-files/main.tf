provider "aws" {
  region = var.aws_region
}

# Generate a new RSA keypair
resource "tls_private_key" "app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair using generated public key
resource "aws_key_pair" "app_key" {
  key_name   = var.key_name
  public_key = tls_private_key.app_key.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.app_key.private_key_pem
  filename        = "${path.module}/app_key.pem"
  file_permission = "0600"
}

# Security group to allow HTTP and SSH
resource "aws_security_group" "app_sg" {
  name        = "app_sggg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# EC2 instance
resource "aws_instance" "app_server" {
  ami                    = "ami-0a313d6098716f372"  # Ubuntu 22.04
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y openjdk-21-jdk maven git

              cd /home/ubuntu

              cat << 'EOT' > deploy.sh
              #!/bin/bash
              STAGE=$1
              if [ -z "$STAGE" ]; then STAGE="Dev"; fi
              echo "Deployment stage: $STAGE"

              if [ "$STAGE" == "Dev" ]; then
                CONFIG_FILE="dev_config"
              elif [ "$STAGE" == "Prod" ]; then
                CONFIG_FILE="prod_config"
              else
                echo "Invalid stage: $STAGE"
                exit 1
              fi

              git clone https://github.com/Manthan1410/tech_eazy_devops_Manthan1410.git app
              cd app || exit

              if [ -f "../$CONFIG_FILE" ]; then
                cp "../$CONFIG_FILE" ./application.properties
              fi

              mvn clean package
              nohup java -jar target/hellomvc-0.0.1-SNAPSHOT.jar --server.port=80 > app.log 2>&1 &
              echo "Application started on port 80"
              EOT

              chmod +x deploy.sh
              ./deploy.sh ${var.stage}
              EOF

  tags = {
    Name = "LiftAndShiftApp"
  }
}
