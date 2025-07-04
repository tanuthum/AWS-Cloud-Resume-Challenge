resource "aws_lambda_function" "visitor_counter" {
  filename         = "${path.module}/../backend/visitor_counter.zip"
  function_name    = "ViewCount"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = filebase64sha256("${path.module}/../backend/visitor_counter.zip")
}


