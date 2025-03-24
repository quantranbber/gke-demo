resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "${var.environment}-${var.project_name}-ingress"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "gce"
      # "networking.gke.io/managed-certificates" = "myapp-cert"
    }
    labels = local.project_tag
  }

  spec {
    # tls {
    #   hosts       = ["myapp-supalongdnszzz.com"]
    #   secret_name = "myapp-tls"
    # }

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.environment}-${var.project_name}-app1-svc"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}