# Vault Hashicorp with Terraform

This repository provides an example setup for deploying HashiCorp Vault with high availability using the Raft consensus protocol on a Kubernetes cluster, using Kind. Additionally, it includes the configuration to enable Prometheus to scrape metrics from Vault, using a Vault-generated token for authentication.

## Vault Deployment Overview

### Vault High Availability

The Vault cluster is configured for high availability (HA) using the Raft consensus protocol. This setup ensures that there is no single point of failure, providing robustness and reliability for secure secrets management.

#### Vault Unsealing Process

Currently, the Vault cluster can only be unsealed manually using the default Shamir's Secret Sharing algorithm. The unsealing process is a manual task, requiring direct intervention whenever Vault is sealed.

### Raft Cluster Pod Configuration Table

| Pod Name | Node Name | Role   | Leader | Voter |
|----------|-----------|--------|--------|-------|
| vault-0  | worker-1  | server | Yes    | Yes   |
| vault-1  | worker-2  | server | No     | Yes   |
| vault-2  | worker-3  | server | No     | Yes   |

## Prometheus Monitoring Integration

### Prometheus and Vault Integration

The module includes the configuration to allow Prometheus to scrape metrics from the Vault server. This integration is enabled by using a Kubernetes secret that stores a Vault token with appropriate policies for accessing Vault's telemetry endpoint. This setup allows Prometheus to authenticate with Vault and securely scrape metrics data.

## Terraform Module Configuration

This Terraform module deploys and configures monitoring components, including Prometheus and Grafana, in a Kubernetes cluster. It also sets up Kubernetes Ingress resources for both Grafana and Prometheus.

### Module Variables

| Name                         | Type     | Description                                                                                 | Default Value                                   |
|------------------------------|----------|---------------------------------------------------------------------------------------------|-------------------------------------------------|
| `grafana_admin_user`         | `string` | The username for Grafana admin login.                                                       | `admin`                                          |
| `grafana_admin_password`     | `string` | The password for Grafana admin login. **Must be provided as a secret.**                      | `""`                                             |
| `grafana_prometheus`         | `string` | The URL of the Prometheus server to be used as a data source in Grafana.                     | N/A                                              |
| `namespace`                  | `string` | The Kubernetes namespace where Prometheus and Grafana will be deployed.                      | `monitoring`                                     |
| `grafana_ingress_config`     | `object` | Configuration object for the Grafana Ingress resource. See details below.                    | `{}`                                             |
| `prometheus_ingress_config`  | `object` | Configuration object for the Prometheus Ingress resource. See details below.                 | `{}`                                             |

### `grafana_ingress_config` Object

| Field         | Type     | Description                                                   | Default Value                 |
|---------------|----------|---------------------------------------------------------------|-------------------------------|
| `name`        | `string` | The name of the Grafana Ingress resource.                     | `grafana-ingress`             |
| `host`        | `string` | The hostname for accessing Grafana via Ingress.               | `grafana.keywe.dev`           |
| `service_name`| `string` | The name of the Grafana Kubernetes service.                   | `grafana`                     |
| `service_port`| `number` | The port number of the Grafana Kubernetes service.            | `80`                          |

### `prometheus_ingress_config` Object

| Field         | Type     | Description                                                   | Default Value                 |
|---------------|----------|---------------------------------------------------------------|-------------------------------|
| `name`        | `string` | The name of the Prometheus Ingress resource.                  | `prometheus-ingress`          |
| `host`        | `string` | The hostname for accessing Prometheus via Ingress.            | `prometheus.labspace.home`    |
| `service_name`| `string` | The name of the Prometheus Kubernetes service.                | `prometheus-server`           |
| `service_port`| `number` | The port number of the Prometheus Kubernetes service.         | `80`                          |

### Module Outputs

Currently, this module does not define any outputs. You can add outputs as needed for your infrastructure requirements.

## Example Usage

```hcl
module "monitoring" {
  source = "./monitoring"

  grafana_admin_user     = "admin"
  grafana_admin_password = "securepassword"
  grafana_prometheus     = "http://prometheus-server.monitoring.svc.cluster.local"
  namespace              = "monitoring"

  grafana_ingress_config = {
    name         = "grafana-ingress"
    host         = "grafana.example.com"
    service_name = "grafana"
    service_port = 80
  }

  prometheus_ingress_config = {
    name         = "prometheus-ingress"
    host         = "prometheus.example.com"
    service_name = "prometheus-server"
    service_port = 80
  }
}


