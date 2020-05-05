resource "aws_iam_role" "main" {
  name               = var.instance_profile_role_name
  tags               = var.tags
  assume_role_policy = file(var.instance_profile_assume_role_policy)
}

resource "aws_iam_instance_profile" "main" {
  name = var.instance_profile_role_name
  role = aws_iam_role.main.name
}

# ------------------------------------------------------------------------------
# No policy file has been specified so we will will create a policy attachment
# using the specified ARN
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "main" {
  count      = fileexists(var.instance_profile_role_policy) ? 0 : 1
  role       = aws_iam_role.main.name
  policy_arn = data.aws_iam_policy.selected.arn
}

# ------------------------------------------------------------------------------
# A policy file has been specified. We read the json policy file into the
# "aws_iam_policy" resource and then we attach it using the
# "aws_iam_role_policy_attachment" resource.
# ------------------------------------------------------------------------------

resource "aws_iam_policy" "file" {
  count  = fileexists(var.instance_profile_role_policy) ? 1 : 0
  name   = aws_iam_role.main.name
  policy = file(var.instance_profile_role_policy)
}

resource "aws_iam_role_policy_attachment" "file" {
  count      = fileexists(var.instance_profile_role_policy) ? 1 : 0
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.file[0].arn
}
