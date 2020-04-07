resource "aws_autoscaling_group" "main" {
  name                      = var.asg_name
  max_size                  = var.asg_max_capacity
  min_size                  = var.asg_min_capacity
  default_cooldown          = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  vpc_zone_identifier       = data.aws_subnet_ids.selected.ids
  target_group_arns         = var.asg_lb_target_group_arns
  load_balancers            = var.asg_clb_names
  termination_policies      = var.asg_termination_policies

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.main.id
        version            = "$Latest"
      }
    }
  }

  tags = [
    var.asg_tags,
    var.tags
  ]

  placement_group           = var.asg_placement_group
  metrics_granularity       = var.asg_metrics_granularity
  enabled_metrics           = var.asg_enabled_metrics
  wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  wait_for_elb_capacity     = local.asg_wait_for_elb_capacity
  service_linked_role_arn   = var.asg_service_linked_role_arn

  lifecycle {
    create_before_destroy = true
  }
}
