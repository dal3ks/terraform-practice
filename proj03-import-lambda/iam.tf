import {
  to = aws_iam_role.lambda_execution_role
  id = "mannually-created-lambda-role-3c3hk03t"
}

import {
  to = aws_iam_policy.lambda_execution
  id = "arn:aws:iam::471112739483:policy/service-role/AWSLambdaBasicExecutionRole-543d711e-70dc-4503-b8ef-7a83be59d086"
}

data "aws_iam_policy_document" "assume_lambda_execution_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "lambda_execution" {
  description = null
  name        = "AWSLambdaBasicExecutionRole-543d711e-70dc-4503-b8ef-7a83be59d086"
  path        = "/service-role/"
  policy = jsonencode({
    Statement = [{
      Action   = "logs:CreateLogGroup"
      Effect   = "Allow"
      Resource = "arn:aws:logs:eu-west-2:471112739483:*"
      }, {
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = ["arn:aws:logs:eu-west-2:471112739483:log-group:/aws/lambda/mannually-created-lambda:*"]
    }]
    Version = "2012-10-17"
  })
  tags     = {}
  tags_all = {}
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_execution_role.json

  name     = "mannually-created-lambda-role-3c3hk03t"
  path     = "/service-role/"
  tags     = {}
  tags_all = {}
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
    role = aws_iam_role.lambda_execution_role.name
    policy_arn = aws_iam_policy.lambda_execution.arn
}