# A Terraform setup that tests the credentials you intend to use

data "aws_caller_identity" "selected" {}
