#
resource "aws_security_group" "lambda" {
  #
  name   = var.lambda_security_group.name
  vpc_id = var.vpc_id

  ingress {
    description = "All ingress for lambda"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All ingress for lambda"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#
data "archive_file" "lambda_code_archive" {
  #
  type        = "zip"
  source_dir  = "lambda-function/code"
  output_path = "lambda-function/code.zip"
}
#
resource "aws_lambda_function" "lambda" {
  #
  function_name    = var.function_name
  filename         = data.archive_file.lambda_code_archive.output_path
  source_code_hash = data.archive_file.lambda_code_archive.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = var.runtime
  handler          = var.handler
  timeout          = var.timeout
  #
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }
  #
  environment {
    variables = {
      aws_tag_filter = "test"

    }
  }
  depends_on = [
    data.archive_file.lambda_code_archive,
    aws_iam_role.iam_for_lambda,
    aws_security_group.lambda
  ]
}