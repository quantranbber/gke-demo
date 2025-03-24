resource "kubernetes_deployment" "app1_deployment" {
  metadata {
    name      = "${var.environment}-${var.project_name}-app1-deployment"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "pending-timeout" = "300"
    }
    labels = merge(tomap({
      app = "${var.environment}-${var.project_name}-app1"
    }), local.project_tag)
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.environment}-${var.project_name}-app1"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.environment}-${var.project_name}-app1"
        }
      }

      spec {
        container {
          name  = "my-app-container"
          image = var.image_name

          port {
            container_port = 3000
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "500Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sub_app1_svc" {
  metadata {
    name      = "${var.environment}-${var.project_name}-app1-svc"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = merge(tomap({
      app = "${var.environment}-${var.project_name}-app1"
    }), local.project_tag)
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = "${var.environment}-${var.project_name}-app1"
    }
    port {
      port        = 80
      target_port = "3000"
    }
  }
}