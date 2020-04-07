# TODO: this needs to be moved to a common 00-data.tf
data "aws_caller_identity" "current" {}

variable "vpc_name"       {}
