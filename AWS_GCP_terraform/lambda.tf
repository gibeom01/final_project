resource "aws_lambda_function" "sns_subscription_lambda" {
  filename         = "sns_subscription_lambda.zip"
  function_name    = "SNSSubscriptionLambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "sns_subscription_lambda.lambda_handler"
  runtime          = "python3.8"
  timeout          = 60

  environment {
    variables = {
      sns_topic_arn = aws_sns_topic.mysqldb_sns.arn
      email         = "rlqja7638@gmail.com"
    }
  }
}

resource "aws_cloudwatch_event_rule" "sns_event_rule" {
  name        = "CloudWatchToSNSLambdaTrigger"
  description = "Trigger Lambda function when CloudWatch alarm is triggered"
  event_pattern = jsonencode({
    source = ["aws.cloudwatch"]
    detail = {
      "alarmName" = ["HealthyHostsAlarmForMySQLNodes", "HealthyHostsAlarmForTomcatNodes"]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_event_target" {
  rule      = aws_cloudwatch_event_rule.sns_event_rule.name
  target_id = "sns-lambda-trigger"
  arn       = aws_lambda_function.sns_subscription_lambda.arn
}

resource "aws_lambda_permission" "allow_event_rule" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_subscription_lambda.function_name
  principal     = "events.amazonaws.com"
  statement_id  = "AllowExecutionFromCloudWatch"
}
