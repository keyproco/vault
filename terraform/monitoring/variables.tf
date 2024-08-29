variable "grafana_admin_user" {
    type = string
}

variable "grafana_admin_password" {
    type = string
}

variable "grafana_prometheus" {
    type = map(string)
}
