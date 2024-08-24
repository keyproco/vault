resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "server.ha.enabled"
    value = true 
  }

  set {
    name  = "server.ha.raft.enabled"
    value = true 
  }
  
  set {
    name  = "server.ha.raft.config"
    value = <<EOT
ui = true

listener "tcp" {
  tls_disable     = 1
  address         = "[::]:8200"
  cluster_address = "[::]:8201"
}

storage "raft" {
  path    = "/vault/data"
  retry_join {
    leader_api_addr = "http://vault-0.vault-internal:8200"
  }

}

service_registration "kubernetes" {}
EOT
  }

  set {
    name  = "server.dataStorage.storageClass"
    value = "standard"
  }
}
