resource "aws_sns_topic" "notification_topic" {
   name = "sns-${var.project_name}"
   tags = {
    Name = "vpc-${var.project_name}"
   }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = var.email
}


