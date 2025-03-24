# resource "google_dns_managed_zone" "my_zone" {
#   name        = "my-zone"
#   dns_name    = "gketestadr020197.com."
#   description = "DNS zone for my domain"
# }

# resource "google_dns_record_set" "alb_record" {
#   name         = "alb.${google_dns_managed_zone.my_zone.dns_name}"
#   type         = "A"
#   ttl          = 0
#   managed_zone = google_dns_managed_zone.my_zone.name
#   rrdatas      = [google_compute_global_address.alb_ip.address]
# }