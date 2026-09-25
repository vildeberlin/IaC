output "subnet_id" {
    description = "Subnett-ID per lag (frontend, backend, database)"
    value       = { for k, s in openstack_networking_subnet_v2.network : k => s.id }
  }

/*skriver ut Subnet ID
output "subnet_id" {
  value = openstack_networking_subnet_v2.network.id
}


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