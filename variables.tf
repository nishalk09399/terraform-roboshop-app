variable "project_name" { #we are leaving it as a blank means it is mandatory and user need to provide this in 07-web module
   
}


variable "env" {
    
}


variable "common_tags" {
}


variable "health_check" {
    default = {
    enabled = true
    healthy_threshold = 2     #we are just hitting url it will check weather it is working or not that is healthcheck
    interval = 15
    matcher = "200-299"
    path = "/health"
    port        = 8080
    protocol    = "HTTP"
    timeout = 5   
    unhealthy_threshold = 3    #we didnt get any response untill 3 sec consider it as unhealthy 
  }

}

variable "target_group_port" {
    default = 8080
}

variable "target_group_protocol" {
    default = "HTTP"

}

variable "vpc_id" {
    
}

variable "launch_template_tags" {
    default = []
}

variable "image_id" {
    
}

variable "instance_type" {
    default = "t2.micro"
}

variable "security_group_id" {
    
}

variable "user_data" {
    default = ""
    
}

#var's for ASG

variable "max_size" {
    default = 10
    
}

variable "min_size" {
    default = 1
    
}

variable "health_check_type" {
    default = "ELB"

    
}

variable "health_check_grace_period" {
    default = 300
    
}

variable "desired_capacity" {
    default = 2 
    
}

variable "vpc_zone_identifier" {
    type = list
    
}

variable "tag" {
default = []
    
}

#var's for ASG policy
variable "autoscaling_cpu_target" {
    default = 70.0
    
}

#var's for web alb listerner rule
variable "alb_listener_arn" {
   
    
}

variable "rule_priority" {
    
    
}

variable "host_header" {
    
    
}
