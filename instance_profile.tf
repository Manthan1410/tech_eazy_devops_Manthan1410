resource "aws_iam_instance_profile" "s3_write_instance_profile" {
  name = "s3-write-profile"
  role = aws_iam_role.s3_write_role.name
}

