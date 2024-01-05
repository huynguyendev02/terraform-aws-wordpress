resource "aws_db_subnet_group" "database_subnet" {
  name = "db-subnet-${var.project_name}"
  subnet_ids = [for subnet in var.subnet : subnet.id if strcontains(subnet.tags.Name, "db")]
  tags = {
    Name = "db-subnetgroup-${var.project_name}"
  }
}

resource "aws_db_instance" "rds_master" {
  identifier              = "master-rds-${var.project_name}"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0.33"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  backup_retention_period = 0
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.database_subnet.id
  skip_final_snapshot     = true
  vpc_security_group_ids  = [var.rds_sg.id]
  storage_encrypted       = false
  tags = {
    Name = "master-rds-${var.project_name}"
  }
}