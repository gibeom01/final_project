resource "aws_cloudwatch_metric_alarm" "mysqldb_healthyhosts" {
  alarm_name          = "HealthyHostsAlarmForMySQLdbNodes"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Number of failed EC2 instance status checks in MySQL EKS nodes"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.mysqldb_sns.arn]
  ok_actions          = [aws_sns_topic.mysqldb_sns.arn]

  dimensions = {
    AutoScalingGroupName = "mysqldb-node-group-asg" 
  }
}

resource "aws_cloudwatch_metric_alarm" "tomcatwas_healthyhosts" {
  alarm_name          = "HealthyHostsAlarmForTomcatwasNodes"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Number of failed EC2 instance status checks in Tomcat EKS nodes"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.tomcatwas_sns.arn]
  ok_actions          = [aws_sns_topic.tomcatwas_sns.arn]

  dimensions = {
    AutoScalingGroupName = "tomcatwas-node-group-asg"  
  }
}

resource "aws_sns_topic" "mysqldb_sns" {
  name = "mysqldb-alerts"
}

resource "aws_sns_topic" "tomcatwas_sns" {
  name = "tomcatwas-alerts"
}

resource "aws_sns_topic_subscription" "mysqldb_email_subscription" {
  topic_arn = aws_sns_topic.mysqldb_sns.arn
  protocol  = "email"
  endpoint  = "rlqja7638@gmail.com"  
}

resource "aws_sns_topic_subscription" "tomcatwas_email_subscription" {
  topic_arn = aws_sns_topic.tomcatwas_sns.arn
  protocol  = "email"
  endpoint  = "rlqja7638@gmail.com" 
}
