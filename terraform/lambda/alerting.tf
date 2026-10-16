resource "aws_sns_topic" "alerts" {
  name = "${var.function_name}-alerts"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_log_metric_filter" "errors" {
  name           = "${var.function_name}-error-filter"
  log_group_name = "/aws/lambda/${var.function_name}"
  pattern        = "?ERROR"

  metric_transformation {
    name      = "Errors"
    namespace = "GaterKeeper/LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "errors" {
  alarm_name          = "${var.function_name}-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.errors.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.errors.metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
}