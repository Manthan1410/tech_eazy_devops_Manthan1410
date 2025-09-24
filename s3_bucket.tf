resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "logs-bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id     = "delete-old-logs"
    status = "Enabled"

    filter {
      prefix = "app/logs/"
    }

    expiration {
      days = 7
    }
  }
}

