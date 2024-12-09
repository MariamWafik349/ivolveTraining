# NETWORK
instance_type = "t2.micro"                           # Instance type for EC2

# sns
sns_topic_name       = "cpu_alert"                   # Name of the SNS Topic
sns_target_protocol  = "email"                       # Protocol used for SNS subscription
sns_topic_target     = "mariamwafik10@gmail.com"   # Target email for SNS notifications

# CloudWatch 
cw_alarm_name          = "high-cpu-utilization-alarm"               # Alarm name
cw_comparison_operator = "GreaterThanThreshold"                    # Comparison operator for alarm
cw_evaluation_periods  = 1                                         # Number of evaluation periods
cw_metric_name         = "CPUUtilization"                          # Metric to monitor
cw_namespace           = "AWS/EC2"                                 # Namespace of the metric
cw_period              = 300                                       # Monitoring period in seconds
cw_statistic           = "Average"                                 # Statistic type for alarm
cw_threshold           = 70                                        # Threshold for triggering the alarm
cw_alarm_description   = "This metric monitors the EC2 instance CPU utilization"  # Description of the alarm

# ec2
vpc_cidr_block          = "10.0.0.0/16"               # CIDR block for the VPC
az                      = "us-east-1a"               # Availability zone
pub_subnet_cidr_block   = "10.0.0.0/24"              # CIDR block for the public subnet
