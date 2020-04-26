variable "instance_profile_role_name" {
  type        = string
  description = "Name of role and instance profile"
}

variable "instance_profile_role_arn" {
  type        = string
  description = "The role ARN to apply to this role"
}

variable "instance_profile_role_policy" {
  type        = string
  default     = "instance-profile-policy-role.json"
  description = "The role policy file to apply to this role"
}

variable "instance_profile_assume_role_policy" {
  type    = string
  default = "instance-profile-policy-assume-role.json"
}
