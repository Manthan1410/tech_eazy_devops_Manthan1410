variable "aws_region" {
  description = "AWS region to deploy EC2 instance"
  type        = string
  default     = "us-east-1"  # Default region; reviewer can override
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "stage" {
  description = "Deployment stage: Dev or Prod"
  type        = string
  default     = "Dev"
}
