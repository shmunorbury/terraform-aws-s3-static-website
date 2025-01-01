resource "aws_cloudwatch_metric_alarm" "email_topic" {
  provider = aws.acm_provider
  count                     = var.admin_email == "" ? 0 : 1
  alarm_name                = "high-traffic-${var.domain_name}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 5
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = var.request_limit
  alarm_description         = "This will fire an alert when the number of requests is more than ${var.request_limit} per minute for 5 consecutive minutes."
  insufficient_data_actions = []
  actions_enabled           = "true"
  alarm_actions             = [aws_sns_topic.sns.arn]
  ok_actions                = [aws_sns_topic.sns.arn]
}

resource "aws_sns_topic" "sns" {
  provider = aws.acm_provider
  name = "email_topic_for_admin"
}

resource "aws_sns_topic_subscription" "email" {
  provider = aws.acm_provider
  count     = var.admin_email == "" ? 0 : 1
  endpoint  = var.admin_email
  protocol  = "email"
  topic_arn = aws_sns_topic.sns.arn
}
