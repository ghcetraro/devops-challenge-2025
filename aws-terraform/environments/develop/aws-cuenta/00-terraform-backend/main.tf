#
resource "aws_dynamodb_table" "dynamodb_lock" {
  name           = "tfstatelocks"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}
#
resource "aws_s3_bucket" "state_bucket" {
  bucket = "aws-cuenta-develop-poc-github"
  #
  tags = local.tags
}

