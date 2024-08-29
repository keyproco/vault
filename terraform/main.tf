module "monitoring" {
    source = "./monitoring"

    grafana_admin_user = var.grafana_admin_user
    grafana_admin_password = var.grafana_admin_password

    grafana_prometheus = var.grafana_prometheus

}