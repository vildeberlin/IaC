# Sample values for the PoC. Run: terraform apply -var-file=poc.tfvars
os_cloud              = "openstack"     # entry in clouds.yaml
external_network_name = "ntnu-internal" # CHANGE: name of your external network

name_prefix  = "terranova-poc"
network_name = "terranova-poc-net"
router_name  = "terranova-poc-router"

subnets = {
  frontend = { cidr = "10.10.1.0/24" }
  backend  = { cidr = "10.10.2.0/24" }
  database = { cidr = "10.10.3.0/24" }
}

admin_cidr          = "0.0.0.0/0" # CHANGE to your IP/32 if possible
keypair_name        = "terranova-poc-key"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"

frontend_name           = "terranova-poc-web"
frontend_instance_count = 2
frontend_image_name     = "ubuntu-22.04" # CHANGE to an image that exists
frontend_flavor_name    = "m1.small"     # CHANGE to a flavor that exists

db_name_prefix    = "terranova-poc-db"
db_instance_count = 1
db_image_name     = "ubuntu-22.04"
db_flavor_name    = "m1.small"
db_volume_keys    = ["dbdata"]
db_database_name  = "appdb"
db_user           = "appuser"
db_password       = "ChangeMe-PoC-only!"

volumes = {
  dbdata = { name = "terranova-poc-dbdata", size_gb = 10 }
}

containers = {
  assets = { name = "terranova-poc-assets" }
}

enable_load_balancer = true
lb_name              = "terranova-poc-lb"
lb_services = {
  http = { protocol = "HTTP", listen_port = 80, member_port = 80, monitor_url_path = "/health" }
}
