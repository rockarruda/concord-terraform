variable "ec2_instance_name" {
  type = string
}

variable "ec2_ssh_port" {
  type = number
  default = 22
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_keypair" {
  type = string
}

variable "ec2_instance_public" {
  type = bool
  default = true
}

# Setting this to "" by passes requiring and actual instance profile. Not sure
# if this is stanard TF behavior, or something about this module, but it prevents
# us from having to create two resources and use the count/ternary trick.
variable "ec2_instance_profile" {
  type = string
  default = ""
}

variable "ec2_user_data" {
  type = string
  default = "provision.sh"
  description = "The user_data file to do the initial compute provisioning"
}

variable "ec2_root_block_device_type" {
  type = string
  default = "gp2"
}

variable "ec2_root_block_device_size" {
  type = number
  default = 10
}

variable "ec2_root_block_device_delete_on_termination" {
  type = bool
  default = true
}
