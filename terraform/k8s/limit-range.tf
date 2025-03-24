resource "kubernetes_limit_range" "app_limit_range" {
  metadata {
    name      = "${var.environment}-${var.project_name}-limit-range"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.project_tag
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "900m"
        memory = "500Mi"
      }
      default_request = {
        cpu    = "500m"
        memory = "128Mi"
      }
      max = {
        cpu    = "1000m"
        memory = "1024Mi"
      }
      min = {
        cpu    = "200m"
        memory = "128Mi"
      }
    }
  }
}