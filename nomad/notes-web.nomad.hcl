job "notes-web-job" {
  type = "service"

  group "notes-web-group" {
    count = 1
    network {
      mode = "bridge"
      port "web" {
        static = 8080
        to = 8080
      }
    }

    service {
      name     = "notes-web-svc"
      port     = "web"

      connect {
        sidecar_service {
          proxy {
            transparent_proxy {}
          }
        }
      }
    }

    task "notes-web-task" {

      env {
        POSTGRES_ADDRESS = "notes-postgres-svc.service.consul"
        POSTGRES_PORT = "5432"
        POSTGRES_USER = "d"
        POSTGRES_PASSWORD = "d"
        POSTGRES_DB = "postgres"
      }

      driver = "docker"

      config {
        image = "notes:0.1.0-SNAPSHOT"
        ports = ["web"]
      }

      # configured because of error
      # fixed memory regions require 589466K which is greater than 300M
      resources {
        memory = 700
      }
    }
  }
}
