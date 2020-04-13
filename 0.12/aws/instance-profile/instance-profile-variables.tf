variable "instance_profile_role_name" {
  type        = string
  description = "Name of role and instance profile"
}

variable "instance_profile_role_arn" {
  type        = string
  description = "The role ARN to apply to this role" 
}
