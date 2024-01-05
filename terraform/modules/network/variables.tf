variable "project_name" {
  type = string
}
variable "project_tag" {
  type = string
}
variable "owner_tag" {
}

variable "network_cidr" {
  type = string
}

variable "networks" {
  type = map(object({
    subnets    = map(object({ 
      cidr_block = string
      availability_zone = string
    }))
  }))
}


