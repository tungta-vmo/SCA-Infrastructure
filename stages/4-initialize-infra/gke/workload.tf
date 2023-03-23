resource "kubernetes_deployment" "frontend" {
  metadata {
    name = var.workload_name
    namespace = var.network_namespace
    labels = {
      app = var.workload_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.workload_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.workload_name
        }
      }
      spec {
        container {
          name = "app"
          image = "nginx:latest"
          port {
            container_port = 80
          }
          security_context {
            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = false
            run_as_non_root            = false

            capabilities {
              add  = []
              drop = [
                  "NET_RAW",
              ]
            }
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "80"
            }

            initial_delay_seconds = 3
            period_seconds = 3
          }
        }
        security_context {
          run_as_non_root = false
          supplemental_groups = []
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        toleration {
          effect   = "NoSchedule"
          key      = "kubernetes.io/arch"
          operator = "Equal"
          value    = "amd64"
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = var.workload_name
    namespace = var.network_namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.frontend.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}