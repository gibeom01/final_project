resource "aws_sns_topic" "mysqldb_sns" {
  name = "mysqldb-alerts"
}

resource "aws_sns_topic" "tomcatwas_sns" {
  name = "tomcatwas-alerts"
}

resource "aws_sns_topic_subscription" "mysqldb_sns_email" {
  topic_arn = aws_sns_topic.mysqldb_sns.arn
  protocol  = "email"
  endpoint  = "rlqja7638@gmail.com"
}

resource "aws_sns_topic_subscription" "tomcatwas_sns_email" {
  topic_arn = aws_sns_topic.tomcatwas_sns.arn
  protocol  = "email"
  endpoint  = "rlqja7638@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "nlb_healthyhosts" {
  alarm_name          = "HealthyHostsAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = 60
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.mysqldb_sns.arn]
  ok_actions          = [aws_sns_topic.mysqldb_sns.arn]
  dimensions = {
    TargetGroup  = aws_lb_target_group.mysqldb_target_group.arn_suffix
    LoadBalancer = aws_lb.mysqldb_nlb.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "tomcatwas_nlb_healthyhosts" {
  alarm_name          = "tomcatwas-nlb-healthyhosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = 60
  statistic           = "Average"
  threshold           = 2 
  alarm_description   = "Number of healthy nodes in Target Group for Tomcat WAS"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.tomcatwas_sns.arn]
  ok_actions          = [aws_sns_topic.tomcatwas_sns.arn]

  dimensions = {
    TargetGroup  = aws_lb_target_group.tomcatwas_target_group.arn_suffix
    LoadBalancer = aws_lb.tomcatwas_nlb.arn_suffix
  }
}

resource "aws_sns_topic" "mysqldb_alerts" {
  name = "mysqldb-alerts"
}

resource "aws_sns_topic" "tomcatwas_alerts" {
  name = "tomcatwas-alerts"
}

resource "aws_sns_topic_subscription" "mysqldb_email_subscription" {
  topic_arn = aws_sns_topic.mysqldb_alerts.arn
  protocol  = "email"
  endpoint  = "rlqja7638@gmail.com"
}

resource "aws_sns_topic_subscription" "tomcatwas_email_subscription" {
  topic_arn = aws_sns_topic.tomcatwas_alerts.arn
  protocol  = "email"
  endpoint  = "rlqja7638@gmail.com"
}
