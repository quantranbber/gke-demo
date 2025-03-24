provider "google" {
  region  = var.default_region
  project = var.project_id
}

provider "google-beta" {
  region  = var.default_region
  project = var.project_id
}

# provider "helm" {
#   kubernetes {
#     host                   = "https://${module.cluster.gke_cluster_endpoint}"
#     token                  = data.google_client_config.default.access_token
#     cluster_ca_certificate = base64decode(module.cluster.gke_cluster_ca_certificate)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "gke-gcloud-auth-plugin"
#     }
#   }
# }

provider "kubernetes" {
  host = "https://${module.cluster.gke_cluster_endpoint}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = []
    command     = "gke-gcloud-auth-plugin"
  }
}

module "cluster" {
  source         = "./cluster"
  default_region = var.default_region
  environment    = var.environment
  project_name   = var.project_name
  project_id     = var.project_id
  zone1          = var.zone1
  nodes_count    = var.nodes_count
  instance_type  = var.instance_type
}

module "k8s" {
  depends_on     = [module.cluster]
  source         = "./k8s"
  default_region = var.default_region
  environment    = var.environment
  project_name   = var.project_name
  image_name     = module.cluster.image_name
}


data "google_client_config" "default" {}