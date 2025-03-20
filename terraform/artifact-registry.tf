resource "google_artifact_registry_repository" "my_repo" {
  location      = var.default_region
  repository_id = "${var.project_name}-repo"
  format        = "DOCKER"
  description   = "Repository for ${var.project_name} images"

  labels = {
    environment = var.environment
    project     = var.project_id
  }
}

resource "google_service_account" "artifact_pusher" {
  account_id   = "artifact-pusher"
  display_name = "Artifact Registry Pusher Service Account"
}

resource "google_service_account_key" "artifact_pusher_key" {
  service_account_id = google_service_account.artifact_pusher.name
}

resource "google_artifact_registry_repository_iam_policy" "repo_policy" {
  location    = google_artifact_registry_repository.my_repo.location
  repository  = google_artifact_registry_repository.my_repo.name
  policy_data = data.google_iam_policy.artifact_policy.policy_data
}

data "google_iam_policy" "artifact_policy" {
  binding {
    role = "roles/artifactregistry.writer"
    members = [
      "serviceAccount:${google_service_account.artifact_pusher.email}",
    ]
  }

  binding {
    role = "roles/artifactregistry.reader"
    members = [
      "serviceAccount:${google_service_account.artifact_pusher.email}",
    ]
  }
}

resource "google_secret_manager_secret" "artifact_pusher_secret" {
  secret_id = "${var.project_name}-artifact-pusher-key"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "artifact_pusher_secret_version" {
  secret      = google_secret_manager_secret.artifact_pusher_secret.id
  secret_data = base64decode(google_service_account_key.artifact_pusher_key.private_key)
}