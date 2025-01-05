job "notes-postgres" {
  type = "service"

  group "notes-postgres-group" {
    count = 1

    volume "postgres" {
      type      = "host"
      read_only = false
      source    = "postgres"
    }

    network {
      mode = "bridge"
      port "postgres" {
        static = 5432
        # TODO find out
        to = 5432
      }
    }

    service {
      name     = "notes-postgres-svc"
      port     = "postgres"

      connect {
        sidecar_service {
          proxy {
            transparent_proxy {}
          }
        }
      }

    }

    task "postgres-task" {

      volume_mount {
        volume      = "postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      env {
        POSTGRES_USER = "d"
        POSTGRES_PASSWORD = "d"
      }

      driver = "docker"

      config {
        image = "postgres:16"
        ports = ["postgres"]
      }
    }

  }
}