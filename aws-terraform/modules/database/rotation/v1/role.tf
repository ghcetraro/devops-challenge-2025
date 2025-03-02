#
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
#
resource "aws_iam_role" "iam_for_lambda" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
#
resource "aws_iam_role_policy_attachment" "aws_policy_vpc" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  depends_on = [
    aws_iam_role.iam_for_lambda
  ]
}
#
resource "aws_iam_role_policy_attachment" "aws_policy_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  depends_on = [
    aws_iam_role.iam_for_lambda
  ]
}
#
data "aws_iam_policy_document" "aws_policy" {
  statement {
    sid    = "DescribeLogStreams"
    effect = "Allow"
    actions = [
      "logs:DescribeLogStreams",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/aws/lambda/${var.function_name}:*",
    ]
  }
  statement {
    sid    = "SecretManager"
    effect = "Allow"
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage",
    ]
    resources = ["*"]
  }
}

#Policy to grant Lambda required permissions
resource "aws_iam_policy" "aws_policy" {
  name   = var.lambda_role_name
  policy = data.aws_iam_policy_document.aws_policy.json
}

#Attach custom policy to lambda role
resource "aws_iam_role_policy_attachment" "aws_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.aws_policy.arn
  depends_on = [
    aws_iam_policy.aws_policy
  ]
}