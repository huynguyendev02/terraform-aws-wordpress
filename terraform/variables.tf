variable "project_name" {
  type = string
}
variable "project_tag" {
  type = string
}
variable "owner_tag" {
  type = string
}
variable "network_cidr" {
  type = string
}
variable "networks" {
  type = map(object({
    subnets = map(object({
      cidr_block        = string
      availability_zone = string
    }))
  }))
}
####SECURITY_GROUP#####
variable "alb_sg" {
  type = map(map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  })))
}
variable "alb_to_ec2_rule" {
  type = list(object({
    type      = string
    from_port = number
    to_port   = number
    protocol  = string
  }))
}
variable "ec2_to_rds_rule" {
  type = list(object({
    type      = string
    from_port = number
    to_port   = number
    protocol  = string
  }))
}
variable "application_info" {
  type = map(string)
}
####COMPUTE#####
variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "volume_size" {
  type = number
}

variable "min_size_asg" {
  type = number
}
variable "desired_capacity_asg" {
  type = number
}
variable "max_size_asg" {
  type = number
}
variable "db_name" {
  type = string
}
variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}

variable "email" {
  type = string
}

variable "domain" {
}
variable "delegation_set" {
  type = string
}