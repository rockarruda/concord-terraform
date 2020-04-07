variable "asg_name" {
  type        = string
  description = "Name of the autoscaling group"
}

variable "asg_lb_target_group_arns" {
  type        = list
  default     = []
  description = "The created ASG will be attached to this target group"
}

variable "asg_clb_names" {
  type        = list
  default     = []
  description = "A list of classic load balancer names to add to the autoscaling group"
}

variable "asg_min_capacity" {
  type        = string
  default     = "0"
  description = "The created ASG will have this number of instances at minimum"
}

variable "asg_max_capacity" {
  type        = string
  default     = "0"
  description = "The created ASG will have this number of instances at maximum"
}

variable "asg_health_check_type" {
  type        = string
  default     = "ELB"
  description = "Controls how ASG health checking is done"
}

variable "asg_health_check_grace_period" {
  type        = string
  default     = "300"
  description = "Time, in seconds, to wait for new instances before checking their health"
}

variable "asg_default_cooldown" {
  type        = string
  default     = "300"
  description = "Time, in seconds, the minimum interval of two scaling activities"
}

variable "asg_placement_group" {
  type        = string
  default     = ""
  description = "The placement group for the spawned instances"
}

variable "asg_metrics_granularity" {
  type        = string
  default     = "1Minute"
  description = "The granularity to associate with the metrics to collect"
}

variable "asg_enabled_metrics" {
  type = list

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  description = "The list of ASG metrics to collect"
}

variable "asg_service_linked_role_arn" {
  type        = string
  default     = ""
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
}

variable "asg_termination_policies" {
  type = list

  default = [
    "Default",
  ]

  description = "Specify policies that the auto scaling group should use to terminate its instances"
}

variable "asg_tags" {
  type        = map
  default     = {}
  description = "The created ASG will have these tags applied over the default ones (see main.tf)"
}

variable "asg_wait_for_capacity_timeout" {
  type        = string
  default     = "0"
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
}

variable "asg_wait_for_elb_capacity" {
  type        = string
  default     = ""
  description = "Terraform will wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. If left to default, the value is set to asg_min_capacity"
}

variable "mixed_instances_distribution" {
  type        = map
  description = "Specify the distribution of on-demand instances and spot instances. See https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_InstancesDistribution.html"

  default = {
    on_demand_allocation_strategy            = "prioritized"
    on_demand_base_capacity                  = "0"
    on_demand_percentage_above_base_capacity = "100"
    spot_allocation_strategy                 = "lowest-price"
    spot_instance_pools                      = "2"
    spot_max_price                           = ""
  }
}
