variable "grafana_admin_user" {
    type = string
}

variable "grafana_admin_password" {
    type = string
}

variable "grafana_prometheus" {
    type = map(string)
}

variable "namespace" {
    type = string
}

variable "prometheus_ingress_config" {
  description = "Configuration for Prometheus ingress"
  type = object({
    name         = string
    host         = string
    service_name = string
    service_port = number
  })
  default = {
    name         = "prometheus-ingress"
    host         = "prometheus.labspace.home"
    service_name = "prometheus-server"
    service_port = 80
  }
}

variable "grafana_ingress_config" {
  description = "Configuration for Grafana Ingress"
  type = object({
    name        = string
    host        = string
    service_name = string
    service_port = number
  })
  default = {
    name         = "grafana-ingress"
    host         = "grafana.keywe.dev"
    service_name = "grafana"
    service_port = 80
  }
}
