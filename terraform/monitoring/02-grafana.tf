resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.4.8"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
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
    name      = var.grafana_ingress_config.name
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/",
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "true"
    }
  }

  spec {
    rule {
      host = var.grafana_ingress_config.host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.grafana_ingress_config.service_name
              port {
                number = var.grafana_ingress_config.service_port
              }
            }
          }
        }
      }
    }
  }
}
