client {
  enabled = true

  host_volume "postgres" {
    # TODO: use your user name here
    path      = "/home/tao/nomad/postgres-data"
    read_only = false
  }

  options {
    "docker.volumes.enabled" = "true"
  }

#   options {
#     "consul.auto_join" = "provider=local"
#     "consul.datacenter" = "dc1"
# #     "consul.retry_join" = ["localhost:4646"]
# #     "consul.retry_interval" = "5s"
#   }

}