
###########################
# grafana variables
# #########################

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type = string
}

variable "grafana_prometheus" {
  type = map(string)

  default = {
    service_type           = "ClusterIP"
    version                = "8.4.8"
    prometheus_data_source = "prometheus"
    prometheus_server      = "http://prometheus-server"
  }
}


variable "grafana_ingress_config" {
  description = "Configuration for Grafana Ingress"
  type = object({
    name         = string
    namespace    = string
    host         = string
    service_name = string
    service_port = number
    annotations  = map(string)
    path         = string
    path_type    = string
  })
  default = {
    name         = "grafana-ingress"
    namespace    = "monitoring"
    host         = "grafana.keywe.dev"
    service_name = "grafana"
    service_port = 80
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
    path      = "/"
    path_type = "Prefix"
  }
}