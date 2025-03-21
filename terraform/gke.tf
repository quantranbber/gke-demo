resource "google_container_cluster" "gke_cluster" {
  name               = "${var.project_name}-gke-cluster"
  location           = var.zone1
  initial_node_count = var.nodes_count
  network            = google_compute_network.vpc.name
  subnetwork         = google_compute_subnetwork.private_subnet.name
  dns_config {
    cluster_dns       = "CLOUD_DNS"
    cluster_dns_scope = "CLUSTER_SCOPE"
  }
  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = true
    }
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }
  workload_identity_config {
    workload_pool = "${data.google_project.current.project_id}.svc.id.goog"
  }
  ip_allocation_policy {}

  remove_default_node_pool = true

  resource_labels = {
    environment = var.environment
    project     = var.project_id
  }
}

resource "google_container_node_pool" "gke_node_pool" {
  name       = "${var.project_name}-node-pool"
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.zone1
  node_count = var.nodes_count

  node_config {
    service_account = google_service_account.gke_sa.email
    machine_type    = var.instance_type
    preemptible     = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      environment = var.environment
      project     = var.project_id
    }

    tags = ["gke-node", "private", var.environment]
  }
}

resource "google_service_account" "gke_sa" {
  account_id   = "gke-artifact-pull"
  display_name = "Service Account for GKE to pull images from Artifact Registry"
}

resource "google_project_iam_member" "artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}