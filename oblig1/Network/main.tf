
//nettverk
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

// subnet (hvorfor er det første subnettet ulikt fra de tre andre?)
resource "openstack_networking_subnet_v2" "frontend" {
  name       = "frontend"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.199.0/24"
  ip_version = 4

  enable_dhcp = true
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]  
}

resource "openstack_networking_subnet_v2" "backend" {
  name       = "backend"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.200.0/24"
  ip_version = 4

  
  enable_dhcp = true
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]  
}

resource "openstack_networking_subnet_v2" "db" {
  name       = "db"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.201.0/24"
  ip_version = 4

  
  enable_dhcp = true
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]  
}
