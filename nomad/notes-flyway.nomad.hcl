job "notes-migrate" {
  type = "batch"

  parameterized {
    meta_required = ["budget"]
  }

  group "notes-migrate-group" {
    count = 1

    task "notes-migrate-task" {

      template {
        data        = <<EOH
{{ range nomadService "postgres-svc" }}
REDIS_HOST={{ .Address }}
REDIS_PORT={{ .Port }}
{{ end }}
# PTC_BUDGET={{ env "NOMAD_META_budget" }}
EOH
        destination = "local/env.txt"
        env         = true
      }
      driver = "docker"

      config {
        image = "ghcr.io/hashicorp-education/learn-nomad-getting-started/ptc-setup:1.0"
      }
    }
  }
}