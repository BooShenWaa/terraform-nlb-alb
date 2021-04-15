resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy"
  description = "Policy to allow lambda to update NLB target groups with ALB IPs"

  policy = file("nlb_TG_populate_policy.json")
}

resource "aws_iam_role" "lb-lambda-role" {
  name = "lb-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.lb-lambda-role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}