module "Network" {
  source = "./modules/Network"

  network_name        = "network"
  network_subnet_name = "network-subnet"
  network_subnet_cidr = "10.0.1.0/24"
  network_router_name = "network"
}

module "Virtual_machine" {
  depends_on = [module.Network]
  source     = "./modules/Virtual_machine"

  name         = "vm"
  ssh_key_name = "ssh_key_name"
  network      = module.Network.network
}

module "object_storage" {
  source = "./modules/Storage_container"

  storage_container_name         = "this"
  storage_container_content_type = "application/octet-stream"
  storage_container_versioning   = false
}

module "Persistent_storage" {
  source = "./modules/Persistent_storage"
  volume_name = "vol"
  volume_size = 20
}