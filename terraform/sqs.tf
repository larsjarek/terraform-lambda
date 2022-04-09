resource "aws_sqs_queue" "queue" {
  name = "lambda-input-sqs"
  tags = local.tags
}