resource "kubernetes_namespace" "app" {
  metadata {
    name = "${var.environment}-${var.project_name}-ns"

    labels = local.project_tag
  }
}