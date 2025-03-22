resource "kubernetes_ingress_v1" "nodejs_ingress" {
  metadata {
    name      = "nodejs-ingress"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "gce"
      # "networking.gke.io/managed-certificates" = "myapp-cert"
    }
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
              name = "sub-app1-svc"
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