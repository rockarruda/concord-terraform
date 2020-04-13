resource "aws_iam_role" "main" {
  name               = var.instance_profile_role_name
  tags               = var.tags
  assume_role_policy = file(var.instance_profile_assume_role_policy)
}

resource "aws_iam_instance_profile" "main" {
  name = var.instance_profile_role_name
  role = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = data.aws_iam_policy.selected.arn
}
