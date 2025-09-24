output "s3_bucket_name" {
  value = aws_s3_bucket.logs_bucket.bucket
}

output "s3_readonly_role_arn" {
  value = aws_iam_role.s3_readonly_role.arn
}

output "s3_write_role_arn" {
  value = aws_iam_role.s3_write_role.arn
}

output "s3_instance_profile" {
  value = aws_iam_instance_profile.s3_write_instance_profile.arn
}

