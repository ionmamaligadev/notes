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
        to = 5432
      }
    }

    service {
      connect {
        sidecar_service {
          proxy {
            transparent_proxy {}
          }
        }
      }


    }

    task "postgres-task" {

      service {
        name     = "notes-postgres-svc"
        port     = "postgres"

        check {
          type    = "script"
          command = "/bin/sh"
          args    = ["-c", "pg_isready -U ${POSTGRES_USER} -d postgres"]
          interval = "2s"
          timeout  = "1s"
        }
      }

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