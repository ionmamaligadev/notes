job "notes-postgres-job" {
  type = "service"

  group "notes-postgres-group" {
    count = 1
    network {
      port "postgres" {
        to = 5432
      }
    }

    service {
      name     = "notes-postgres-svc"
      port     = "postgres"
      provider = "nomad"
    }

    task "postgres-task" {

      template {
        data        = <<EOH
POSTGRES_USER=d
POSTGRES_PASSWORD=d
EOH
        destination = "local/env.txt"
        env         = true
      }

      driver = "docker"

      config {
        image = "postgres:16"
        ports = ["postgres"]
      }
    }
  }
}