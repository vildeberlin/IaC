output "subnet_id" {
    description = "Subnett-ID per lag (frontend, backend, database)"
    value       = { for k, s in openstack_networking_subnet_v2.network : k => s.id }
  }

output "network_id" {
    value = openstack_networking_network_v2.network.id  
}

output "network_name" {
  description = "Navn på nettverket"
  value = openstack_networking_network_v2.network.name
}

output "router_id" {
  description = "ID til ruteren"
  value       = openstack_networking_router_v2.network.id
}

