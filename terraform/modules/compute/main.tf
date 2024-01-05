resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ssh-${var.project_name}"
  public_key = file("${path.module}/key/id_rsa.pub")
  tags = {
    Name = "ec2-key-${var.project_name}"
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/userdata/userdata.sh")}"

  vars = {
    db_name = var.rds_master.db_name
    username = var.rds_master.username
    password = var.rds_master.password
    endpoint = var.rds_master.endpoint
  }
}



resource "aws_launch_template" "launch_template" {
  name = "lt-${var.project_name}"
  
  image_id = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.ec2_key_pair.key_name
  
  user_data = base64encode(data.template_file.init.rendered)

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [var.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ec2-${var.project_name}"
    }
  }

  tags = {
    Name = "lt-${var.project_name}"
  }

}

