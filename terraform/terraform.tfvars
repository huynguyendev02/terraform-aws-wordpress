project_name = "huyng14-aps-1-d-wordpress"
project_tag  = "Wordpress-HuyNG14"
owner_tag = "HuyNG14-Terraform"
network_cidr = "10.0.0.0/16"

networks = {
  "public" = {
    subnets = {
      "public-subnet-1" = {
        cidr_block        = "10.0.0.0/20"
        availability_zone = "ap-southeast-1a"
      }
      "public-subnet-2" = {
        cidr_block        = "10.0.16.0/20"
        availability_zone = "ap-southeast-1b"
      }
      "public-subnet-3" = {
        cidr_block        = "10.0.32.0/20"
        availability_zone = "ap-southeast-1c"
      }
    }
  },
  "private" = {
    subnets = {
      "private-subnet-1" = {
        cidr_block        = "10.0.128.0/20"
        availability_zone = "ap-southeast-1a"
      }
      "private-subnet-2" = {
        cidr_block        = "10.0.144.0/20"
        availability_zone = "ap-southeast-1b"
      }
      "private-subnet-3" = {
        cidr_block        = "10.0.160.0/20"
        availability_zone = "ap-southeast-1c"
      }
      "db-subnet-1" = {
        cidr_block        = "10.0.48.0/25"
        availability_zone = "ap-southeast-1a"
      }
      "db-subnet-2" = {
        cidr_block        = "10.0.48.128/25"
        availability_zone = "ap-southeast-1b"
      }
      "db-subnet-3" = {
        cidr_block        = "10.0.49.0/25"
        availability_zone = "ap-southeast-1c"
      }
    }
  }
}

alb_sg = {
  "inbound" = {
    "http" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "https" = {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  },
  "outbound" = {
    "all" = {
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

alb_to_ec2_rule = [{
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
}]

ec2_to_rds_rule = [{
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
}]

application_info = {
  port = 80
  protocol = "HTTP"
}


ami           = "ami-0b607b177398bba3f"
instance_type = "t2.micro"
volume_size = 8

min_size_asg = 3
desired_capacity_asg = 3
max_size_asg = 4

db_name = "wordpress"
db_user = "wordpress"
db_password = "wordpress"

email = "huynguyendev02@gmail.com"
domain = "huienv.click"
delegation_set = "N088044219WD0833BH8AG"