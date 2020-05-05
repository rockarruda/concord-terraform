data "aws_iam_policy" "selected" {
  arn = var.instance_profile_role_arn
}
