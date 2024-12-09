variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az" {
  description = "The Availability Zone to deploy resources"
  type        = string
  default     = "us-east-1a"
}

variable "pub_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "ami_data_source" {
  description = "AMI data source for Ubuntu"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic for alerts"
  type        = string
  default     = "cpu_alert"
}

variable "sns_topic_target" {
  description = "The email address for SNS alerts"
  type        = string
  default     = "maryamabualmajd@gmail.com"
}

variable "sns_target_protocol" {
  description = "The protocol for SNS alerts"
  type        = string
  default     = "email"
}

variable "cw_alarm_name" {
  description = "The name of the CloudWatch alarm"
  type        = string
  default     = "high-cpu-utilization-alarm"
}

variable "cw_comparison_operator" {
  description = "Comparison operator for the alarm threshold"
  type        = string
  default     = "GreaterThanThreshold"
}

variable "cw_evaluation_periods" {
  description = "The number of periods to evaluate the metric"
  type        = number
  default     = 1
}

variable "cw_metric_name" {
  description = "The metric to monitor"
  type        = string
  default     = "CPUUtilization"
}

variable "cw_namespace" {
  description = "The namespace of the metric"
  type        = string
  default     = "AWS/EC2"
}

variable "cw_period" {
  description = "The period in seconds for the metric evaluation"
  type        = number
  default     = 300
}

variable "cw_statistic" {
  description = "The statistic type for the alarm"
  type        = string
  default     = "Average"
}

variable "cw_threshold" {
  description = "The threshold for the alarm"
  type        = number
  default     = 70
}

variable "cw_alarm_description" {
  description = "Description of the CloudWatch alarm"
  type        = string
  default     = "This metric monitors the EC2 instance CPU utilization"
}
