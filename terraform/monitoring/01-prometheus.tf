resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  
  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

}

#####################
# Prometheus Secret Token permits prometheus server 
# to scrape metrics from Hashicorp Vault Server
#####################
resource "kubernetes_secret" "prometheus_token" {
  metadata {
    name      = "prometheus-token-secret"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "prometheus-token" = file("${path.module}/prometheus-token")
  }
}

#####################
# Ingress Prometheus Endpoints
#####################
resource "kubernetes_ingress_v1" "prometheus_ingress" {
  metadata {
    name      = var.prometheus_ingress_config.name
    namespace = kubernetes_namespace.monitoring.metadata[0].name

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/",
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "true"
    }
  }

  spec {
    rule {
      host = var.prometheus_ingress_config.host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.prometheus_ingress_config.service_name
              port {
                number = var.prometheus_ingress_config.service_port
              }
            }
          }
        }
      }
    }
  }
}
