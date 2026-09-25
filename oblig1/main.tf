module "Network" {
    source = "./Network"

    network_name          = var.network_name
    network_subnet_name   = "${var.network_name}-subnet"
    network_subnet_cidr   = var.subnet_cidrs
    network_router_name   = var.router_name
    subnet                = var.subnet_cidrs
    ntnu_internal_network = var.external_network_name
  }

/*module "Network" {
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
}*/

  module "vm_frontend" {
    source = "./Virtual_machine"

    name           = var.frontend_vm_name
    flavor         = var.frontend_flavor
    distro         = var.image_name
    ssh_key_name   = var.ssh_key_name
    network_id     = module.Network.network_id
    subnet_id      = module.Network.subnet_ids["frontend"]
    template       = "${path.root}/${var.frontend_template}"
    secgroup_name  = var.frontend_secgroup_name
    security_rules = local.frontend_rules
  }

  module "vm_db" {
    source = "./Virtual_machine"

    name           = var.db_vm_name
    flavor         = var.db_flavor
    distro         = var.image_name
    ssh_key_name   = var.ssh_key_name
    network_id     = module.Network.network_id
    subnet_id      = module.Network.subnet_ids["database"]
    template       = "${path.root}/${var.db_template}"
    secgroup_name  = var.db_secgroup_name
    security_rules = local.db_rules
  }


/*
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
  */

module "object_storage" {
  source = "./Storage_container"

  storage_container_name         = var.storage_container_name
}

  module "Persistent_storage" {
    source = "./Persistent_storage"

    name                 = var.volume_name
    size_gb              = var.volume_size_gb
    attach_storage_to_vm = var.attach_volume
    instance_id          = module.vm_db.vm_id
  }

/*
module "Persistent_storage" {
  depends_on = [module.Virtual_machine]
  source = "./Persistent_storage"

  name = "vol"
  instance_id = module.vm_db.vm_id  
}*/

  module "Load_balancer" {
    source = "./Load_balancer"

    flag                  = var.enable_load_balancer
    lb_name               = var.lb_name
    protocol              = var.lb_protocol
    protocol_port         = var.lb_port
    member_address        = module.vm_frontend.vm_ip
    member_subnet_id      = module.Network.subnet_ids["frontend"]
    external_network_name = var.external_network_name
  }

/*
module "Load_balancer" {
  depends_on = [module.Network]
  source = "./Load_balancer"

  lb_name = "lb"
  member_address    = module.vm_frontend.vm_ip
  member_subnet_id  = module.Network.subnet_ids["frontend"]
}*/