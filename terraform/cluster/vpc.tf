resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-${var.project_name}-gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.environment}-${var.project_name}-gke-private-subnet"
  ip_cidr_range            = "10.0.1.0/28"
  region                   = var.default_region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "${var.environment}-${var.project_name}-gke-router"
  region  = var.default_region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name   = "${var.environment}-${var.project_name}-gke-nat"
  router = google_compute_router.router.name
  region = var.default_region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  nat_ip_allocate_option = "AUTO_ONLY"
}