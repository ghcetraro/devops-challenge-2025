#
resource "aws_security_group" "jumper" {
  name   = var.instance.name
  tags   = local.tags
  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#
resource "aws_instance" "jumper" {
  ami                         = var.instance.ami
  instance_type               = var.instance.instance_type
  key_name                    = local.ssh_key_name
  subnet_id                   = var.vpc.subnets_0
  vpc_security_group_ids      = [aws_security_group.jumper.id]
  associate_public_ip_address = var.instance.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.master.name
  #
  root_block_device {
    delete_on_termination = true
    volume_size           = var.instance.volume_size
    volume_type           = var.instance.volume_type
    iops                  = var.instance.iops
  }
  #
  user_data = templatefile("./template/runner.sh", {})
  #
  tags = merge(
    { Name = "devops-${var.environment}-jumper-server" },
    local.tags
  )
  #
  depends_on = [
    resource.aws_security_group.jumper
  ]
}