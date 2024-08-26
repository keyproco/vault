# Vault Hashicorp with Terraform

This repository provides an example setup of deploying HashiCorp Vault with high availability using the Raft consensus protocol on a Kubernetes cluster using Kind.

### Vault Unsealing Process

Currently, the Vault cluster can only be unsealed manually using the default Shamir's Secret Sharing algorithm. This means the unsealing process is a manual task, requiring direct intervention whenever Vault is sealed.

### Raft Cluster Pod Configuration Table

| **Pod Name** | **Node Name**  | **Role**   | **Leader** | **Voter** |
|--------------|----------------|------------|------------|-----------|
| `vault-0`    | `worker-1`     | `server`   | Yes        | Yes       |
| `vault-1`    | `worker-2`     | `server`   | No         | Yes       |
| `vault-2`    | `worker-3`     | `server`   | No         | Yes       |

