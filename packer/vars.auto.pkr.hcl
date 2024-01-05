variable "ami_name" {
    default = "wordpress-ubuntu-huyng14"
}
variable "region" {
    default = "ap-southeast-1"
}
variable "project_name" {
    default = "huyng14-aps-1-d-wordpress"
}
variable "project_tag" {
    default = "Wordpress-HuyNG14"
}
variable "owner_tag" {
    default = "HuyNG14-Terraform"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "source_ami_name" {
    default = "ami-03caf91bb3d81b843"
}
variable "ssh_username" {
    default = "ubuntu"
}