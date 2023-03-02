# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/opt/nomad/data"

# Enable the server
server {
  enabled = true
}
# Enable the client as well
client {
  enabled = true
  meta {
    greengrass_ipc = "server"
  }
  options = {
    "driver.raw_exec.enable" = "1"
  }
}

# port for the ui
ports {
  http = 8080
}