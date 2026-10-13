import {
  to = aws_iam_role.lambda_execution_role
  id = "mannually-created-lambda-role-3c3hk03t"
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name     = "mannually-created-lambda-role-3c3hk03t"
  path     = "/service-role/"
  tags     = {}
  tags_all = {}
}