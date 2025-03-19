resource "local_file" "artifact_key" {
  content  = base64decode(google_service_account_key.artifact_pusher_key.private_key)
  filename = "${path.module}/artifact-pusher-key.json"
}

locals {
  image_tag = formatdate("YYYYMMDDHHMMss", timestamp())
  img_name  = "${google_artifact_registry_repository.my_repo.location}-docker.pkg.dev/${data.google_project.current.project_id}/${google_artifact_registry_repository.my_repo.repository_id}/${var.environment}-${var.project_name}:${local.image_tag}"
}

# TODO: save in env or secret manager
resource "null_resource" "docker_auth" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud auth activate-service-account --key-file=${local_file.artifact_key.filename}
      gcloud auth configure-docker ${google_artifact_registry_repository.my_repo.location}-docker.pkg.dev --quiet
    EOT
  }

  depends_on = [local_file.artifact_key, google_artifact_registry_repository_iam_policy.repo_policy, local.image_tag]
}

resource "null_resource" "build_push_image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/.."
    command     = "docker build -t ${local.img_name} . && docker push ${local.img_name}"
  }

  depends_on = [null_resource.docker_auth]
}