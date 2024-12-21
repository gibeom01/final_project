import boto3
import json
import os

# SNS 클라이언트 및 CloudWatch 클라이언트 초기화
sns_client = boto3.client('sns')
cloudwatch_client = boto3.client('cloudwatch')

def lambda_handler(event, context):
    # 이메일 주소를 환경 변수로부터 가져옵니다.
    email_address = os.environ['EMAIL_ADDRESS']
    
    # SNS 구독 활성화
    sns_topic_arn_mysqldb = os.environ['SNS_TOPIC_ARN_MYSQLDB']
    sns_topic_arn_tomcatwas = os.environ['SNS_TOPIC_ARN_TOMCATWAS']
    
    # SNS 주제에 이메일 구독 추가
    subscribe_to_sns(sns_topic_arn_mysqldb, email_address)
    subscribe_to_sns(sns_topic_arn_tomcatwas, email_address)
    
    # CloudWatch Alarm 설정
    create_cloudwatch_alarm(sns_topic_arn_mysqldb, "HealthyHostsAlarm", "mysqldb")
    create_cloudwatch_alarm(sns_topic_arn_tomcatwas, "tomcatwas-nlb-healthyhosts", "tomcatwas")

    return {
        'statusCode': 200,
        'body': json.dumps('SNS Subscription and CloudWatch alarms created successfully!')
    }

def subscribe_to_sns(topic_arn, email):
    try:
        response = sns_client.subscribe(
            TopicArn=topic_arn,
            Protocol='email',
            Endpoint=email
        )
        print(f"Subscribed to {topic_arn} with response: {response}")
    except Exception as e:
        print(f"Error subscribing to SNS topic {topic_arn}: {str(e)}")

def create_cloudwatch_alarm(topic_arn, alarm_name, application_name):
    try:
        response = cloudwatch_client.put_metric_alarm(
            AlarmName=alarm_name,
            ComparisonOperator='LessThanThreshold',
            EvaluationPeriods=1,
            MetricName='HealthyHostCount',
            Namespace='AWS/NetworkELB',
            Period=60,
            Statistic='Average',
            Threshold=2,
            ActionsEnabled=True,
            AlarmActions=[topic_arn],
            OKActions=[topic_arn],
            Dimensions=[
                {
                    'Name': 'TargetGroup',
                    'Value': f'{application_name}_target_group_arn'
                },
                {
                    'Name': 'LoadBalancer',
                    'Value': f'{application_name}_nlb_arn'
                }
            ]
        )
        print(f"Created CloudWatch alarm for {application_name} with response: {response}")
    except Exception as e:
        print(f"Error creating CloudWatch alarm for {application_name}: {str(e)}")
