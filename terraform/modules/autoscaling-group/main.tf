resource "aws_placement_group" "placement_group" {
  name = "placement-group-${var.project_name}"
  strategy = "spread"
}
resource "aws_autoscaling_group" "asg" {
  name = "asg-${var.project_name}"

  min_size                  = var.min_size_asg
  max_size                  = var.max_size_asg
  desired_capacity          = var.desired_capacity_asg

  health_check_type         = "ELB"
  target_group_arns = [var.alb_tg.arn]

  placement_group = aws_placement_group.placement_group.id
  vpc_zone_identifier       =  [for subnet in var.subnet : subnet.id if strcontains(subnet.tags.Name, "private")]
  
  launch_template {
    id      = var.launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "asg-${var.project_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_tag
    propagate_at_launch = true
  }
  tag {
    key                 = "CreatedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asp-scale_down-${var.project_name}"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type = "StepScaling"
  estimated_instance_warmup = 120
  adjustment_type        = "PercentChangeInCapacity"

  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
    scaling_adjustment         = 0
  }
  step_adjustment {
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10 
    scaling_adjustment         = -40
  }
  step_adjustment {
    metric_interval_upper_bound = -20
    scaling_adjustment         = -30
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "cwa-scale_down-${var.project_name}"
  alarm_description   = "Scale down when CPU utilization < 25%"

  alarm_actions       = [
    aws_autoscaling_policy.scale_down.arn,
    var.notification_topic.arn
  ]
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "3"
  period              = "60"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  tags = {
    Name = "cwa-scale_down-${var.project_name}"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "asp-scale_up-${var.project_name}"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type = "StepScaling"
  estimated_instance_warmup = 120
  adjustment_type        = "PercentChangeInCapacity"

  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
    scaling_adjustment         = 40
  }
  step_adjustment {
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20  
    scaling_adjustment         = 50
  }
  step_adjustment {
    metric_interval_lower_bound = 20
    scaling_adjustment         = 60
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "cwa-scale_up-${var.project_name}"
  alarm_description   = "Scale up when CPU utilization > 80%"

  alarm_actions       = [
    aws_autoscaling_policy.scale_up.arn,
    var.notification_topic.arn
  ]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "80"
  evaluation_periods  = "3"
  period              = "60"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  tags = {
    Name = "cwa-scale_up-${var.project_name}"
  }
}