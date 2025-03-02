#
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "devops-${var.environment}-IAMR-ECS"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags               = local.tags
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
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/${var.cluster.name}:*",
    ]
  }
}
#
resource "aws_iam_policy" "aws_policy" {
  name   = "devops-${var.environment}-IAMP-ECS"
  policy = data.aws_iam_policy_document.aws_policy.json
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "aws_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.aws_policy.arn
  depends_on = [
    aws_iam_role.ecsTaskExecutionRole,
    aws_iam_policy.aws_policy
  ]
}
#
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  depends_on = [
    aws_iam_role.ecsTaskExecutionRole,
  ]
}
#
resource "aws_iam_role_policy_attachment" "ecs_ecr" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  depends_on = [
    aws_iam_role.ecsTaskExecutionRole,
  ]
}
#
data "aws_iam_policy_document" "secretsmanager" {
  statement {
    sid    = "DescribeLogStreams"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = ["*"]
  }
}
#
resource "aws_iam_policy" "secretsmanager" {
  name   = "${var.project}-${var.environment}-IAMP-SM"
  path   = "/"
  policy = data.aws_iam_policy_document.secretsmanager.json
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "secretsmanager" {
  policy_arn = aws_iam_policy.secretsmanager.arn
  role       = aws_iam_role.ecsTaskExecutionRole.name
  depends_on = [
    aws_iam_policy.secretsmanager
  ]
}