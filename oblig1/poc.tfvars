/* dette ble gitt av claude alt

# Nettverk
  network_name          = "terranova-poc-net"
  router_name           = "terranova-poc-router"
  external_network_name = "ntnu-internal"
  subnet_cidr = {
    frontend = "10.0.1.0/24"
    backend  = "10.0.2.0/24"
    database = "10.0.3.0/24"
  }

  # VM-er
  ssh_key_name      = "DITT-NØKKELNAVN"   # <-- bytt til nøkkelen din i SkyHiGh
  image_name        = "Debian 13 (Trixie) stable amd64"
  frontend_vm_name  = "terranova-frontend"
  frontend_flavor   = "gx1.1c1r"
  frontend_template = "templates/frontend-init.yaml"
  db_vm_name        = "terranova-db"
  db_flavor         = "gx1.1c1r"
  db_template       = "templates/db-init.yaml"

  # Sikkerhetsgrupper
  frontend_secgroup_name = "terranova-frontend-sg"
  db_secgroup_name       = "terranova-db-sg"
  ssh_allowed_cidr       = "0.0.0.0/0"
  frontend_public_ports  = [80, 443]
  db_port                = 5432

  # Lastbalanserer
  enable_load_balancer = true
  lb_name              = "terranova-lb"
  lb_protocol          = "HTTP"
  lb_port              = 80
  lb_health_check_path = "/"
  
  # Persistent lagring
  attach_volume  = true
  volume_name    = "terranova-db-volume"
  volume_size_gb = 20

  # Storage container
  storage_container_name = "terranova-container"

*/