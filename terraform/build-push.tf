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
    command = "gcloud secrets versions access latest --secret=${google_secret_manager_secret.artifact_pusher_secret.secret_id} --project=${data.google_project.current.project_id} | gcloud auth activate-service-account --key-file=/dev/stdin && gcloud auth configure-docker ${google_artifact_registry_repository.my_repo.location}-docker.pkg.dev --quiet"
  }

  depends_on = [google_secret_manager_secret_version.artifact_pusher_secret_version, google_artifact_registry_repository_iam_policy.repo_policy, local.image_tag]
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

resource "google_secret_manager_secret" "image_secret" {
  secret_id = "${var.project_name}-image-name"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "image_secret_version" {
  secret      = google_secret_manager_secret.image_secret.id
  secret_data = local.img_name
}