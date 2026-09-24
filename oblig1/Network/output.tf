// skriver ut Subnet ID
output "subnet_id" {
  value = openstack_networking_subnet_v2.subnet.id
}

/*
output "network_name" {
  value = openstack_networking_network_v2.network.name
}

output "subnet_name" {
  value = openstack_networking_subnet_v2.network.name
}
output "router_id" {
  value = openstack_networking_router_v2.network.id
}
*/