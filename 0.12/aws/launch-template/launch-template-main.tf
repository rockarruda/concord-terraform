resource "aws_launch_template" "main" {
  name          = var.launch_template_name
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.launch_template_instance_type

  iam_instance_profile {
    name = var.launch_template_instance_profile
  }

  credit_specification {
    cpu_credits = var.launch_template_cpu_credits
  }

  # We add the security groups to the network_interfaces and omit the
  # "vpc_security_group_ids" parameter as it causes:
  #
  # https://github.com/terraform-providers/terraform-provider-aws/issues/4570
  #
  # InvalidQueryParameter: Invalid launch template: When a network interface is provided, the security groups must be a part of it
  #
  # This suggestion in the comments fixes the issue:
  # https://github.com/terraform-providers/terraform-provider-aws/issues/4570#issuecomment-456624525
  #
  # The example in the Terraform docs is wrong
  #
  #vpc_security_group_ids = data.aws_security_groups.selected.ids

  key_name               = var.launch_template_keypair
  user_data              = filebase64(var.launch_template_user_data)

  network_interfaces {
    associate_public_ip_address = var.launch_template_associate_public_ip
    security_groups = data.aws_security_groups.selected.ids
  }

  monitoring {
    enabled = var.launch_template_monitoring
  }

  ebs_optimized = var.launch_template_ebs_optimized

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.launch_template_volume_size
      volume_type           = var.launch_template_volume_type
      delete_on_termination = var.launch_template_delete_on_termination
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.launch_template_name
    }
  }
}
