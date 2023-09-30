/* this is the module where we are developing and using this all resources as a user in "07-web" module

here we are going to create 

target group of web
launch template of web
autoscaling web
autoscaling policy web 
A listerner rule in alb to route the traffic
web instance should get traffic from web alb on port 80 

You can refer the resources from the 05-catalogue script it will help you */


#first we are creating the target group for our web component

resource "aws_alb_target_group" "main" {
  name        = "${var.project_name}-${var.common_tags.Component}"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id

  #this is the block here 
  health_check {
    enabled = var.health_check.enabled
    healthy_threshold = var.health_check.healthy_threshold    #we are just hitting url it will check weather it is working or not that is healthcheck
    interval = var.health_check.interval
    matcher = var.health_check.matcher
    path = var.health_check.path
    port        = var.health_check.port
    protocol    = var.health_check.protocol
    timeout = var.health_check.timeout  
    unhealthy_threshold = var.health_check.unhealthy_threshold   #we didnt get any response untill 3 sec consider it as unhealthy 
  }
}

#below is web launch template 

resource "aws_launch_template" "main" {
  name = "${var.project_name}-${var.common_tags.Component}"

  image_id = var.image_id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]

  dynamic tag_specifications {
    for_each = var.launch_template_tags
    content {
      resource_type = tag_specifications.value["resource_type"]
      tags = tag_specifications.value["tags"]

      }
    }

    user_data = var.user_data
}

#below we are creating web autoscalinggroup 


resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-${var.common_tags.Component}"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  target_group_arns = [aws_alb_target_group.main.arn]
  launch_template  {
    id =  aws_launch_template.main.id
    version = "$Latest"
  }

  vpc_zone_identifier       = var.vpc_zone_identifier

  dynamic tag {
    for_each = var.tag 
    content {
      key                 = tag.value["key"]
      value               = tag.value["value"]
      propagate_at_launch = tag.value["propagate_at_launch"]

    }
  }

} 

#below we are creating web autoscaling group policy

resource "aws_autoscaling_policy" "main" {
  autoscaling_group_name = aws_autoscaling_group.main.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.autoscaling_cpu_target
  }
}

#below we are creating listerner rule for web ALB

resource "aws_lb_listener_rule" "main" {
  listener_arn = var.alb_listener_arn
  priority     = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }

  condition {
    host_header {
      values = [var.host_header]
    }
  }
}

