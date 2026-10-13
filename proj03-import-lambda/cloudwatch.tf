import {
  to = aws_cloudwatch_log_group.lambda
  id = "/aws/lambda/mannually-created-lambda"
}
resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/mannually-created-lambda"
}
