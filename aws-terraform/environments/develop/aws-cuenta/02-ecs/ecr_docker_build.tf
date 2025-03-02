#
variable "force_image_rebuild" {
  type    = bool
  default = false
}
#
resource "null_resource" "docker_login" {
  triggers = {
    detect_docker_source_changes_public = timestamp()
  }
  provisioner "local-exec" {
    command = local.dkr_login_cmd
  }
}
#
resource "docker_image" "image" {
  for_each = var.services
  name     = "${aws_ecr_repository.app_ecr_repo[each.key].repository_url}:${var.cluster.tag}"
  build {
    context = "${path.module}/docker-images"
  }
  #
  depends_on = [
    aws_ecr_repository.app_ecr_repo,
    null_resource.docker_login
  ]
}
#
resource "docker_registry_image" "image" {
  for_each      = var.services
  name          = docker_image.image[each.key].name
  keep_remotely = true
  #
  depends_on = [
    aws_ecr_repository.app_ecr_repo,
    null_resource.docker_login,
    docker_image.image
  ]
}