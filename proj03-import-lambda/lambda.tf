import {
  to = aws_lambda_function.this
  id = "mannually-created-lambda"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.root}/build/index.mjs"
  output_path = "${path.root}/lambda.zip"
}
resource "aws_lambda_function" "this" {
  architectures    = ["x86_64"]
  description      = "A starter AWS Lambda function."
  filename         = "lambda.zip"
  function_name    = "mannually-created-lambda"
  handler          = "index.handler"
  role             = aws_iam_role.lambda_execution_role.arn
  runtime          = "nodejs22.x"
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  tags = {
    "lambda-console:blueprint" = "hello-world"
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/mannually-created-lambda"
  }
  tracing_config {
    mode = "PassThrough"
  }
}
