# Dexter Monitoring Demo
This repo contains the configurations used to demo the observability stack of Kubernetes

## Running the Stack
You would need an `Azure` account and authenticated terminal with `az login` to run the stack. **However**, the observability stack can run on any Kubernetes cluster

## Other Kubernetes Clusters
You can copy/paste the following lines into your Terraform to install the stack into your cluster

```terraform
provider "helm" {
  kubernetes {
    host                   = 
    username               = 
    password               = 
    client_certificate     = 
    client_key             = 
    cluster_ca_certificate = 
  }
}

resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [
    file("${path.module}/values/kube-prometheus-stack.yaml")
  ]
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"

  values = [
    file("${path.module}/values/loki.yaml")
  ]
}

resource "helm_release" "promtail" {
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"

  values = [
    file("${path.module}/values/promtail.yaml")
  ]
}
```

Be aware to copy/paste the `terraform/values` directory intto your terraform module as well 