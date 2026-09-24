locals {
  default_security_groups = {
    ssh = {
      description = "SSH access"
      rules       = [{ port_min = 22, port_max = 22, remote_ip_prefix = var.admin_cidr }]
    }
    web = {
      description = "HTTP/HTTPS from anywhere"
      rules = [
        { port_min = 80, port_max = 80 },
        { port_min = 443, port_max = 443 },
      ]
    }
    db = {
      description = "PostgreSQL from frontend and backend subnets only"
      rules = [
        { port_min = 5432, port_max = 5432, remote_ip_prefix = var.subnets["frontend"].cidr },
        { port_min = 5432, port_max = 5432, remote_ip_prefix = var.subnets["backend"].cidr },
      ]
    }
  }

  security_groups = merge(local.default_security_groups, var.security_groups == null ? {} : var.security_groups)
}

resource "openstack_compute_keypair_v2" "this" {
  name       = var.keypair_name
  public_key = file(pathexpand(var.ssh_public_key_path))
}

module "network" {
  source = "./modules/network"

  name_prefix           = var.name_prefix
  network_name          = var.network_name
  external_network_name = var.external_network_name
  router_name           = var.router_name
  subnets               = var.subnets
  security_groups       = local.security_groups
}

module "persistent_storage" {
  source  = "./modules/persistent-storage"
  volumes = var.volumes
}

module "storage_container" {
  source     = "./modules/storage-container"
  containers = var.containers
}

module "frontend_vm" {
  source = "./modules/virtual-machine"

  name               = var.frontend_name
  instance_count     = var.frontend_instance_count
  image_name         = var.frontend_image_name
  flavor_name        = var.frontend_flavor_name
  key_pair           = openstack_compute_keypair_v2.this.name
  network_id         = module.network.network_id
  subnet_id          = module.network.subnet_ids["frontend"]
  security_group_ids = [module.network.security_group_ids["ssh"], module.network.security_group_ids["web"]]
  assign_floating_ip = var.frontend_assign_floating_ip
  floating_ip_pool   = var.external_network_name
  volume_ids         = [for k in var.frontend_volume_keys : module.persistent_storage.volume_ids[k]]

  user_data = templatefile(var.frontend_cloud_init_template, {
    role = "frontend"
  })

  depends_on = [module.network]
}

module "db_vm" {
  source = "./modules/virtual-machine"

  name               = var.db_name_prefix
  instance_count     = var.db_instance_count
  image_name         = var.db_image_name
  flavor_name        = var.db_flavor_name
  key_pair           = openstack_compute_keypair_v2.this.name
  network_id         = module.network.network_id
  subnet_id          = module.network.subnet_ids["database"]
  security_group_ids = [module.network.security_group_ids["ssh"], module.network.security_group_ids["db"]]
  assign_floating_ip = false
  volume_ids         = [for k in var.db_volume_keys : module.persistent_storage.volume_ids[k]]

  user_data = templatefile(var.db_cloud_init_template, {
    db_name      = var.db_database_name
    db_user      = var.db_user
    db_password  = var.db_password
    allowed_cidr = var.subnets["frontend"].cidr
  })

  depends_on = [module.network]
}

module "load_balancer" {
  source = "./modules/load-balancer"
  count  = var.enable_load_balancer ? 1 : 0

  name               = var.lb_name
  vip_subnet_id      = module.network.subnet_ids["frontend"]
  member_subnet_id   = module.network.subnet_ids["frontend"]
  member_addresses   = module.frontend_vm.private_ips
  services           = var.lb_services
  assign_floating_ip = var.lb_assign_floating_ip
  floating_ip_pool   = var.external_network_name
}
