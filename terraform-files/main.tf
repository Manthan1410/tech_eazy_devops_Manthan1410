provider "aws" {
  region = var.aws_region
}

# Security group to allow HTTP
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow HTTP"

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
  ami           = "ami-0a313d6098716f372"  # Ubuntu 22.04
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y openjdk-21-jdk maven git

              cd /home/ubuntu

              # Stage-based deploy script
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

              # Clone your GitHub repo
              git clone https://github.com/Manthan1410/tech_eazy_devops_Manthan1410.git app
              cd app || exit

              # Copy stage config if exists
              if [ -f "../$CONFIG_FILE" ]; then
                cp "../$CONFIG_FILE" ./application.properties
              fi

              # Build and run the app
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
