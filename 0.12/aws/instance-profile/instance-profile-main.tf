resource "aws_iam_instance_profile" "main" {
  name = "${var.instance_profile_role_name}-instance-profile"
  role = data.aws_iam_role.selected.name
}
