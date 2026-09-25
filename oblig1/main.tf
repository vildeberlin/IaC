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

module "vm_frontend" {
  source     = "./Virtual_machine"

  name         = "frontend"
  ssh_key_name  = var.ssh_key_name
  network_id    = module.Network.network_id
  subnet_id     = module.Network.subnet_ids["frontend"]
  template      = "${path.root}/templates/frontend-init.yaml"
  secgroup_name = "frontend-secgroup"

  security_rules = {
    ssh   = { port = 22,  protocol = "tcp", cidr = "0.0.0.0/0" }
    http  = { port = 80,  protocol = "tcp", cidr = "0.0.0.0/0" }
  }
}

 module "vm_db" {
    source = "./Virtual_machine"

    name          = "db"
    ssh_key_name  = var.ssh_key_name
    network_id    = module.Network.network_id
    subnet_id     = module.Network.subnet_ids["database"]
    template      = "${path.root}/templates/db-init.yaml"
    secgroup_name = "db-secgroup"
    
    security_rules = {
      ssh      = { port = 22,   protocol = "tcp", cidr = "0.0.0.0/0" }
      postgres = { port = 5432, protocol = "tcp", cidr = "10.0.1.0/24" } # bare fra frontend-subnettet
    }
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