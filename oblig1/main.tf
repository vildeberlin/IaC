module "Network" {
  source = "./Network"

  network_name        = "network"
  network_subnet_name = "network-subnet"
  network_subnet_cidr = {
    frontend = "10.0.1.0/24"
    backend  = "10.0.2.0/24"
    database = "10.0.3.0/24"
  }
  network_router_name = "network"
  subnet = {
    frontend = "10.0.1.0/24"
    backend  = "10.0.2.0/24"
    database = "10.0.3.0/24"
  }
}

module "Virtual_machine" {
  depends_on = [module.Network]
  source     = "./Virtual_machine"

  name         = "vm"
  ssh_key_name = "ssh_key_name"
  network      = module.Network.network
  secgroup_name = "vm-secgroup"
}

module "object_storage" {
  source = "./Storage_container"

  storage_container_name         = "this"
}

module "Persistent_storage" {
  depends_on = [module.Virtual_machine]
  source = "./Persistent_storage"

  name = "vol"
  instance_id = module.vm_db.vm_id  
}

module "Load_balancer" {
  depends_on = [module.Network]
  source = "./Load_balancer"

  lb_name = "lb"
  member_address    = module.vm_frontend.vm_ip
  member_subnet_id  = module.Network.subnet_ids["frontend"]
}