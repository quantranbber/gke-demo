output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.control_plane_endpoints_config[0].dns_endpoint_config[0].endpoint
}

output "gke_cluster_ca_certificate" {
  sensitive = true
  value     = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}