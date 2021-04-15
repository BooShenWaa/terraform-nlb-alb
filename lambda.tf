# Zip function
data "archive_file" "init"{
    type = "zip"
    source_dir = "populate_NLB_TG_with_ALB"
    output_path = "populate_NLB_TG_with_ALB.zip"
}

# Create the Lambda 
resource "aws_lambda_function" "populate_NLB_TG" {
  function_name = "populate_NLB_TG"

  filename         = data.archive_file.init.output_path
  source_code_hash = filebase64sha256(data.archive_file.init.output_path)

  role    = aws_iam_role.lb-lambda-role.arn
  handler = "populate_NLB_TG_with_ALB.lambda_handler"
  runtime = "python2.7"

  environment {
    variables = {
      ALB_DNS_NAME = aws_lb.app-lb.dns_name
      ALB_LISTENER = 80
      S3_BUCKET = aws_s3_bucket.populate_NLB_TG_bucket.bucket
      NLB_TG_ARN = aws_lb_target_group.nlb-tg.arn
      MAX_LOOKUP_PER_INVOCATION = "50"
      INVOCATIONS_BEFORE_DEREGISTRATION = "3"
      CW_METRIC_FLAG_IP_COUNT = true
    }
  }
}

# Schedule Lambda
resource "aws_cloudwatch_event_rule" "populate_NLB_TG" {
  name = "populate_NLB_TG"
  description = "Populate NLB target group with ALB eni IPs"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "populate_NLB_TG" {
  rule = aws_cloudwatch_event_rule.populate_NLB_TG.name
  target_id = "value"
  arn = aws_lambda_function.populate_NLB_TG.arn
}

# Allow CLoudWatch to invoke lambda 
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.populate_NLB_TG.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.populate_NLB_TG.arn
}