
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
        service_type = "ClusterIP"
        version =  "8.4.8"
        prometheus_data_source = "prometheus"
        prometheus_server = "http://prometheus-server"
    }
}
