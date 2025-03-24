resource "kubernetes_resource_quota" "app_quota" {
  metadata {
    name      = "${var.environment}-${var.project_name}-quota"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.project_tag
  }

  spec {
    hard = {
      "requests.cpu"           = "4"
      "requests.memory"        = "4Gi"
      "limits.cpu"             = "4"
      "limits.memory"          = "4Gi"
      "pods"                   = "10"
      "count/deployments.apps" = "5"
    }
  }
}