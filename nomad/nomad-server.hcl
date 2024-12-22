bind_addr = "0.0.0.0"
data_dir = "/tmp/nomad/datadir"

log_level = "INFO"
log_file  = "/tmp/nomad/nomad.log"

server {
  enabled = true
  bootstrap_expect = 1
}
