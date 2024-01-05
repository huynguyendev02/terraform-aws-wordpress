####SECURITY_GROUP#####
variable "project_name" {
  type = string
}
variable "project_tag" {
  type = string
}
variable "owner_tag" {
}

variable "alb_sg" {
  type = map(map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  })))
}
variable "alb_to_ec2_rule" {
}
variable "ec2_to_rds_rule" {
}
####EXTERNAL#####
variable "vpc" {
}
