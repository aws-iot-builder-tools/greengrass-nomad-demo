# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/opt/nomad/data"

client {
  enabled = true
  servers = ["<SERVER_DNS_NAME>"]
  meta {
    greengrass_ipc = "client"
  }
  options = {
    "driver.raw_exec.enable" = "1"
  }
}

plugin "docker" {
  config {
    auth {
      # Nomad will prepend "docker-credential-" to the helper value and call
      # that script name.
      helper = "ecr-login"
    }
  }
}

# different port than server
ports {
  http = 5656
}