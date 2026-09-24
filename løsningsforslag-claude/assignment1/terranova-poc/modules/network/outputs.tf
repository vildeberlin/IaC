output "network_id" {
  value = openstack_networking_network_v2.this.id
}

output "subnet_ids" {
  value = { for k, s in openstack_networking_subnet_v2.this : k => s.id }
}

output "router_id" {
  value = openstack_networking_router_v2.this.id
}

output "security_group_ids" {
  value = { for k, sg in openstack_networking_secgroup_v2.this : k => sg.id }
}
