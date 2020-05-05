variable "launch_template_name" {
  type        = string
  description = "Launch template name"
}

variable "launch_template_instance_type" {
  type        = string
  description = "Instance type"
}

variable "launch_template_instance_profile" {
  type        = string
  description = "Instance profile name"
}

variable "launch_template_cpu_credits" {
  type        = string
  default     = "unlimited"
  description = "The credit option for CPU usage, can be either 'standard' or 'unlimited'"
}

variable "launch_template_keypair" {
  type        = string
  description = "Keypair"
}

variable "launch_template_associate_public_ip" {
  type        = string
  default     = "true"
  description = "Whether to associate public IP to the instance"
}

variable "launch_template_monitoring" {
  type        = string
  default     = "true"
  description = "The spawned instances will have enhanced monitoring if enabled"
}

variable "launch_template_ebs_optimized" {
  type        = string
  default     = "true"
  description = "The spawned instances will have EBS optimization if enabled"
}

variable "launch_template_user_data" {
  type        = string
  default     = "provision.sh"
  description = "The spawned instances will have this user data. Use the rendered value of a terraform's `template_cloudinit_config` data" // https://www.terraform.io/docs/providers/template/d/cloudinit_config.html#rendered
}

variable "launch_template_volume_size" {
  description = "The size of the volume in gigabytes"
  type        = string
  default     = "8"
}

variable "launch_template_volume_type" {
  description = "The type of volume. Can be standard, gp2, or io1"
  type        = string
  default     = "gp2"
}

variable "launch_template_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  default     = "true"
}
