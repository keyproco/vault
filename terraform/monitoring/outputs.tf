output "grafana_endpoint" {

    value = "https://${kubernetes_ingress_v1.grafana_ingress.spec[0].rule[0].host}"
}