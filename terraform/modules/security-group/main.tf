
resource "aws_security_group" "alb_sg" {
  name = "alb-sg-${var.project_name}"
  description = "Security Group for ALB"

  dynamic "ingress" {
    for_each = var.alb_sg["inbound"]
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.alb_sg["outbound"]
    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  vpc_id = var.vpc.id
  tags = {
    Name = "sg-alb-${var.project_name}"
  }
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg-${var.project_name}"
  description = "Security Group for EC2-Wordpress"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc.id
  tags = {
    Name = "sg-ec2-${var.project_name}"
  }
}

resource "aws_security_group_rule" "alb_to_ec2" {
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.alb_sg.id

  count                    = length(var.alb_to_ec2_rule)
  type                     = var.alb_to_ec2_rule[count.index].type
  from_port                = var.alb_to_ec2_rule[count.index].from_port
  to_port                  = var.alb_to_ec2_rule[count.index].to_port
  protocol                 = var.alb_to_ec2_rule[count.index].protocol
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg-${var.project_name}"
  description = "Security Group for RDS-Wordpress"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc.id
  tags = {
    Name = "sg-rds-${var.project_name}"
  }
}


resource "aws_security_group_rule" "ec2_to_rds" {
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id

  count                    = length(var.ec2_to_rds_rule)
  type                     = var.ec2_to_rds_rule[count.index].type
  from_port                = var.ec2_to_rds_rule[count.index].from_port
  to_port                  = var.ec2_to_rds_rule[count.index].to_port
  protocol                 = var.ec2_to_rds_rule[count.index].protocol
}
