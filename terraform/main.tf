module "monitoring" {
  source = "./monitoring"

  grafana_admin_user     = var.grafana_admin_user
  grafana_admin_password = var.grafana_admin_password

  grafana_prometheus = var.grafana_prometheus
  namespace          = "monitoring"

  grafana_ingress_config = {
    name         = "grafana-ingress"
    host         = "grafana.keywe.dev"
    service_name = "grafana"
    service_port = 80
  }

  prometheus_ingress_config = {
    name         = "prometheus-ingress"
    host         = "prometheus.labspace.home"
    service_name = "prometheus-server"
    service_port = 80

  }
}
  