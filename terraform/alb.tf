# # Global IP Address cho Load Balancer
# resource "google_compute_global_address" "alb_ip" {
#   name = "alb-ip"
# }

# # Health Check cho GKE
# resource "google_compute_health_check" "alb_health_check" {
#   name = "alb-health-check"
#   http_health_check {
#     port         = 80
#     request_path = "/health"
#   }
# }

# # Backend Service trỏ đến GKE qua NEG
# resource "google_compute_backend_service" "alb_backend" {
#   name        = "alb-backend"
#   protocol    = "HTTP"
#   port_name   = "http"
#   timeout_sec = 30

#   backend {
#     group = google_compute_network_endpoint_group.gke_neg.id
#   }

#   health_checks = [google_compute_health_check.alb_health_check.id]
# }

# # Network Endpoint Group (NEG) cho GKE Service
# resource "google_compute_network_endpoint_group" "gke_neg" {
#   name                  = "gke-neg"
#   network               = "default"
#   subnetwork            = "default"
#   zone                  = var.zone1
#   network_endpoint_type = "GCE_VM_IP_PORT"

#   depends_on = [kubernetes_service.nodejs_service]
# }

# # URL Map
# resource "google_compute_url_map" "alb_url_map" {
#   name            = "alb-url-map"
#   default_service = google_compute_backend_service.alb_backend.id
# }

# # HTTP Proxy
# resource "google_compute_target_http_proxy" "alb_proxy" {
#   name    = "alb-proxy"
#   url_map = google_compute_url_map.alb_url_map.id
# }

# # Forwarding Rule
# resource "google_compute_global_forwarding_rule" "alb_forwarding_rule" {
#   name       = "alb-forwarding-rule"
#   target     = google_compute_target_http_proxy.alb_proxy.id
#   port_range = "80"
#   ip_address = google_compute_global_address.alb_ip.address
# }