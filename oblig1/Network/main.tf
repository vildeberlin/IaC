
//Netverk
resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = "true"
}

//Subnett
resource "openstack_networking_subnet_v2" "network" {
  name        = var.network_subnet_name
  network_id  = openstack_networking_network_v2.network.id
  cidr        = var.network_subnet_cidr
  ip_version  = 4
  enable_dhcp = true
  dns_nameservers = ["8.8.8.8", "1.1.1.1"] 
}

//Ruter
resource "openstack_networking_router_v2" "network" {
  name                = var.network_router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ntnu_internal.id
}

//kobler subnett og ruter sammen
resource "openstack_networking_router_interface_v2" "network" {
  router_id = openstack_networking_router_v2.network.id
  subnet_id = openstack_networking_subnet_v2.network.id
}