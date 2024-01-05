module "network" {
  source       = "./modules/network"
  project_tag  = var.project_tag
  project_name = var.project_name
  owner_tag = var.owner_tag

  network_cidr = var.network_cidr
  networks     = var.networks
}

module "security-group" {
  source       = "./modules/security-group"
  project_tag  = var.project_tag
  project_name = var.project_name
  owner_tag = var.owner_tag

  alb_sg          = var.alb_sg
  alb_to_ec2_rule = var.alb_to_ec2_rule
  ec2_to_rds_rule = var.ec2_to_rds_rule

  vpc = module.network.vpc
  depends_on = [
    module.network
  ]
}

module "load-balancer" {
  source       = "./modules/load-balancer"
  project_tag  = var.project_tag
  project_name = var.project_name
  owner_tag = var.owner_tag

  alb_sg = module.security-group.alb_sg
  application_info = var.application_info
  domain = var.domain

  vpc = module.network.vpc
  subnet = module.network.subnet
  depends_on = [
    module.security-group
  ]
}


module "compute" {
    source  = "./modules/compute"
    project_tag = var.project_tag
    project_name = var.project_name
    owner_tag = var.owner_tag
    ami = var.ami
    instance_type = var.instance_type
    volume_size = var.volume_size
    rds_master = module.database.rds_master
    ec2_sg = module.security-group.ec2_sg
    depends_on = [
        module.security-group,
        module.database
    ]
}

module "autoscaling-group" {
    source  = "./modules/autoscaling-group"
    project_tag = var.project_tag
    project_name = var.project_name
    owner_tag = var.owner_tag
   
    min_size_asg = var.min_size_asg
    max_size_asg = var.max_size_asg
    desired_capacity_asg = var.desired_capacity_asg
    alb_tg = module.load-balancer.alb_tg
    launch_template = module.compute.launch_template
    subnet = module.network.subnet

    notification_topic = module.notification.notification_topic

    depends_on = [
        module.load-balancer,
        module.notification
    ]
}

module "database" {
    source  = "./modules/database"
    project_tag = var.project_tag
    project_name = var.project_name
    owner_tag = var.owner_tag

    db_name = var.db_name
    db_user = var.db_user
    db_password = var.db_password
    rds_sg = module.security-group.rds_sg
    subnet = module.network.subnet

    depends_on = [
        module.security-group
    ]
}

module "notification" {
    source  = "./modules/notification"
    project_tag = var.project_tag
    project_name = var.project_name
    owner_tag = var.owner_tag

    email = var.email
}


module "resource-group" {
    source  = "./modules/resource-group"
    project_tag = var.project_tag
    project_name = var.project_name
    owner_tag = var.owner_tag

}

module "route53" {
    source  = "./modules/route53"
    project_name = var.project_name

    domain = var.domain
    delegation_set = var.delegation_set
    alb = module.load-balancer.alb

    depends_on = [
        module.load-balancer
    ]
}

