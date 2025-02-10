provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.name
  }
}

resource "helm_release" "argocd" {
  name       = var.name
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.version

  values = [
    <<EOF
server:
  service:
    type: LoadBalancer
EOF
  ]
}
