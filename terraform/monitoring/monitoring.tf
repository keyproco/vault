resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  
  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

}







resource "kubernetes_secret" "prometheus_token" {
  metadata {
    name      = "prometheus-token-secret"
    namespace = "monitoring"
  }

  data = {
    "prometheus-token" = file("${path.module}/prometheus-token")
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.4.8"
  namespace  = "monitoring"
  values = [
    <<EOF
service:
  type: ${var.grafana_prometheus.service_type}
datasources:
 datasources.yaml:
   apiVersion: 1
   datasources:
   - name: Prometheus
     type: prometheus
     url: http://prometheus-server
adminUser: ${var.grafana_admin_user}
adminPassword:  ${var.grafana_admin_password}
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    - name: 'default'
      orgId: 1
      folder: ''
      type: file
      disableDeletion: false
      editable: true
      options:
        path: /var/lib/grafana/dashboards/default

dashboards:
  default:
    echo:
      json: |
        ${indent(8, file("${path.module}/dashboards/vault.json"))}
EOF
  ]
}


resource "kubernetes_ingress_v1" "grafana_ingress" {
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "grafana.keywe.dev"

      http {
        path {
          path = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "grafana"
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


resource "kubernetes_ingress_v1" "prometheus_ingress" {
  metadata {
    name      = "prometheus-ingress"
    namespace      = "monitoring"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "prometheus.labspace.home"

      http {
        path {
          path = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "prometheus-server"
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