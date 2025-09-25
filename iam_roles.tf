resource "aws_iam_role" "s3_readonly_role" {
  name = "S3ReadOnlyRole"  

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole" 
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "s3_readonly_policy" {
  name   = "S3ReadOnlyPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Effect   = "Allow"
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "readonly_attach" {
  role       = aws_iam_role.s3_readonly_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

# Role 1.b 
resource "aws_iam_role" "s3_write_role" {
  name = "S3WriteOnlyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "s3_write_policy" {
  name   = "S3WriteOnlyPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:CreateBucket", "s3:PutObject"]
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Deny"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "write_attach" {
  role       = aws_iam_role.s3_write_role.name
  policy_arn = aws_iam_policy.s3_write_policy.arn
}

