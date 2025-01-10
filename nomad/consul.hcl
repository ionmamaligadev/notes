# TODO make sure you use your user name
data_dir = "/home/tao/consul/datadir"
log_level = "DEBUG"

client_addr = "0.0.0.0"

server = true

ui_config {
  enabled = true
}

advertise_addr = "127.0.0.1"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

bootstrap = true

