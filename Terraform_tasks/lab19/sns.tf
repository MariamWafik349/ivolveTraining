resource "aws_sns_topic" "cpu_alert_topic" {
  name = "Lab19-CPU-Alert-Topic" # Provide a descriptive name for the topic
}

resource "aws_sns_topic_subscription" "cpu_alert_target" {
  topic_arn = aws_sns_topic.cpu_alert_topic.arn
  protocol  = "email" # Assuming email for alerting
  endpoint  = "mariamwafik10@gmail.com" # Replace with your email address
}
