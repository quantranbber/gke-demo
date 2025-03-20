# resource "google_api_gateway_api" "api" {
#   provider     = google-beta
#   api_id       = "my-api"
#   display_name = "My API Gateway"

#   depends_on = [google_compute_global_address.alb_ip]
# }

# resource "google_api_gateway_api_config" "api_config" {
#   provider      = google-beta
#   api           = google_api_gateway_api.api.api_id
#   api_config_id = "my-api-config"

#   openapi_documents {
#     document {
#       path = "spec.yaml"
#       contents = base64encode(templatefile("${path.module}/spec.yaml", {
#         # TODO: fix hard code
#         backend_address = "alb.gketestadr020197.com"
#       }))
#     }
#   }
# }

# resource "google_api_gateway_gateway" "gateway" {
#   provider     = google-beta
#   api_config   = google_api_gateway_api_config.api_config.id
#   gateway_id   = "my-gateway"
#   region       = "asia-east1"
#   display_name = "My Gateway"
# }