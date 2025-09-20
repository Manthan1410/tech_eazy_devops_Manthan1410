output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.app_server.public_dns
}

output "app_url" {
  description = "URL to access the deployed application"
  value       = "http://${aws_instance.app_server.public_ip}:80"
}
