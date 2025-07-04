data "aws_caller_identity" "current" {}

// Create IAM Role
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-viewcount-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

// IAM Policy to Access DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "lambda-dynamodb-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["dynamodb:GetItem", "dynamodb:UpdateItem"],
      Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/ViewCount"
    }]
  })
}

// Attach AWS's Built-in Lambda Execution Policy
resource "aws_iam_role_policy_attachment" "attach_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach Your Custom DynamoDB Policy
resource "aws_iam_role_policy_attachment" "attach_dynamo" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

