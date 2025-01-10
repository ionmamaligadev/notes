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