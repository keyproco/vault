output "grafana_url" {

    value = "https://${kubernetes_ingress_v1.grafana_ingress.spec[0].rule[0].host}"
}

output "prometheus_url" {

    value = "http://${kubernetes_ingress_v1.prometheus_ingress.spec[0].rule[0].host}"
}