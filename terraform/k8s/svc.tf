resource "kubernetes_deployment" "app1_deployment" {
  metadata {
    name      = "app1-deployment"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "pending-timeout" = "300"
    }
    labels = {
      app = "sub-app1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sub-app1"
      }
    }

    template {
      metadata {
        labels = {
          app = "sub-app1"
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
    name      = "sub-app1-svc"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "sub-app1"
    }
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = "sub-app1"
    }
    port {
      port        = 80
      target_port = "3000"
    }
  }
}