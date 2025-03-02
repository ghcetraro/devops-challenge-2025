#
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "trastPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
#
resource "aws_iam_role" "master" {
  name               = "devops-${var.environment}-jumper-IAM-ROLE-MASTER"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
#
resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.master.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [aws_iam_role.master]
}
#
resource "aws_iam_instance_profile" "master" {
  name = "devops-${var.environment}-jumper-IAM-INSTANCE_PROFILE"
  role = aws_iam_role.master.name
}
#
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.master.name
}