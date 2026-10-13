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
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "lambda_execution" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    ]
    actions = ["logs:CreateLogGroup"]
  }

  statement {
    effect = "Allow"
    resources = [
      "${aws_cloudwatch_log_group.lambda.arn}:*"
    ]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "lambda_execution" {
  description = null
  name        = "AWSLambdaBasicExecutionRole-543d711e-70dc-4503-b8ef-7a83be59d086"
  path        = "/service-role/"
  policy      = data.aws_iam_policy_document.lambda_execution.json
  tags        = {}
  tags_all    = {}
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_execution_role.json

  name     = "mannually-created-lambda-role-3c3hk03t"
  path     = "/service-role/"
  tags     = {}
  tags_all = {}
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}