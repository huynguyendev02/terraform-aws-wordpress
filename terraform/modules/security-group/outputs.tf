output "alb_sg" {
  value = aws_security_group.alb_sg
}
output "ec2_sg" {
  value = aws_security_group.ec2_sg
}
output "rds_sg" {
  value = aws_security_group.rds_sg
}