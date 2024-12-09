resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name                = "HighCPUAlarm"
  comparison_operator       = "GreaterThanThreshold"  # Trigger when metric exceeds threshold
  evaluation_periods        = 2                       # Number of periods to evaluate
  metric_name               = "CPUUtilization"        # Metric to monitor
  namespace                 = "AWS/EC2"              # CloudWatch namespace
  period                    = 60                      # Metric collection interval (in seconds)
  statistic                 = "Average"              # Aggregation type
  threshold                 = 70                     # Trigger threshold for CPU utilization
  alarm_description         = "Alarm when CPU utilization exceeds 70%"
  insufficient_data_actions = []                     # No action on insufficient data
  ok_actions                = [aws_sns_topic.alerts.arn] # Notify on recovery
  alarm_actions             = [aws_sns_topic.alerts.arn] # Notify when alarm triggers

  dimensions = {
    InstanceId = aws_instance.web.id                  # Attach alarm to specific EC2 instance
  }
}
