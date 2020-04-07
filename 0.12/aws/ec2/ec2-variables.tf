variable "instance_name" {
  type = string
}

variable "ssh_port" {
  type = number
  default = 22
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "keypair" {
  type = string
}

variable "instance_public" {
  type = bool
  default = true
}

variable "ec2_user_data" {
  type = string
  default = ""
  description = "The user_data file to do the initial compute provisioning"
}
