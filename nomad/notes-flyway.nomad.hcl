job "notes-flyway" {
  type = "batch"

  group "notes-flyway-group" {
    count = 1
    restart {
      attempts = 0
    }

    network {
      mode = "bridge"
    }

    service {
      name = "notes-flyway-svc"

      connect {
        sidecar_service {
          proxy {
            transparent_proxy {}
          }
        }
      }
    }

    task "await-postgres-service" {
      driver = "docker"

      config {
        image        = "busybox:1.28"
        command      = "sh"
        args         = ["-c", "echo -n 'Waiting for service'; until nslookup notes-postgres-svc.service.consul 2>&1 >/dev/null; do echo '.'; sleep 2; done"]
        network_mode = "host"
      }

      resources {
        cpu    = 200
        memory = 128
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "notes-flyway-task" {

      env {
        POSTGRES_ADDRESS = "notes-postgres-svc.service.consul"
        POSTGRES_PORT = "5432"
        POSTGRES_USER = "d"
        POSTGRES_PASSWORD = "d"
        POSTGRES_DB = "postgres"
      }

      driver = "docker"

      config {
        image = "flyway/flyway:10.18.0"
        command = "migrate"
        volumes = [
          # TODO make sure you use your path to project
          "/mnt/c/Users/Artiom/Documents/Intellij/notes/flyway/flyway.conf:/flyway/conf/flyway.conf",
          "/mnt/c/Users/Artiom/Documents/Intellij/notes/flyway/sql:/flyway/sql"
        ]
      }
    }
  }
}