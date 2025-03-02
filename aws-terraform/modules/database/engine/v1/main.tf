#
resource "random_password" "postgresql_master_password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}
#
resource "aws_db_subnet_group" "postgresql" {
  name       = var.cluster.name
  subnet_ids = ["${var.vpc.subnets_0}", "${var.vpc.subnets_1}"]
  tags       = var.tags
}
#
resource "aws_security_group" "postgresql" {
  name        = var.cluster.name
  vpc_id      = var.vpc.vpc_id
  description = "Control traffic to/from RDS"
  tags        = var.tags

  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#
resource "aws_db_instance" "default" {
  identifier             = var.cluster.name
  engine                 = var.cluster.engine
  engine_version         = var.cluster.version
  instance_class         = var.cluster.instance_class
  allocated_storage      = var.cluster.allocated_storage
  storage_type           = var.storage_type
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.postgresql.name
  username               = var.master_username
  kms_key_id             = var.kms_id
  password               = random_password.postgresql_master_password.result
  skip_final_snapshot    = true
  storage_encrypted      = var.storage_encrypted
  tags                   = var.tags
  vpc_security_group_ids = ["${aws_security_group.postgresql.id}"]
}
#
resource "aws_secretsmanager_secret" "sc" {
  name = var.cluster.name
  tags = var.tags
}
#
resource "aws_secretsmanager_secret_version" "sc" {
  secret_id = aws_secretsmanager_secret.sc.id
  # encode in the required format
  secret_string = jsonencode(
    {
      DATABASE_USER = var.master_username
      DATABASE_PASS = random_password.postgresql_master_password.result
      ENGINE        = "postgresql"
      DATABASE_HOST = aws_db_instance.default.endpoint
      DATABASE_PORT = "5432"
      DATABASE_URL  = "postgresql://${var.master_username}:${random_password.postgresql_master_password.result}@${aws_db_instance.default.endpoint}:5432/${var.db_name}"
    }
  )
  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}