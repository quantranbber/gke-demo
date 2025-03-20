provider "google" {
  region  = var.default_region
  project = var.project_id
}

provider "google-beta" {
  region  = var.default_region
  project = var.project_id
}

# provider "kubernetes" {
#   host                   = "https://${google_container_cluster.free_tier_cluster.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.free_tier_cluster.master_auth[0].cluster_ca_certificate)
#     exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "gke-gcloud-auth-plugin"
#   }
# }


data "google_project" "current" {}
data "google_client_config" "default" {}