# upload files to S3 bucket
resource "aws_s3_object" "zip" {
  bucket = aws_s3_bucket.bucket.id
  key    = "example-${var.commit_hash}.zip"
  source = "../example/example.zip"
}

# lambda SQS trigger
resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.lambda.arn
}

# create lambda
resource "aws_lambda_function" "lambda" {
  function_name = "${local.service_name}_${var.env}"

  s3_bucket = aws_s3_bucket.bucket.id
  s3_key    = aws_s3_object.zip.key

  handler = "index.handler"
  runtime = local.lambda_runtime
  role    = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      "LOG_LEVEL" : var.log_level
      "AWS_ACCOUNT" : var.aws_account
    }
  }

  tags = local.tags
}

# create IAM role
resource "aws_iam_role" "lambda_role" {
  name = "${local.service_name}_${var.env}_role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "lambda.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
}

# create IAM policy
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.service_name}_${var.env}_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action = [
          "sqs:*"
        ]
        Resource = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect = "Allow"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}
