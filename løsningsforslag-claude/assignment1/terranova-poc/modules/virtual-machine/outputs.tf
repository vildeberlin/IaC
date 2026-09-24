output "ids" {
  value = openstack_compute_instance_v2.this[*].id
}

output "names" {
  value = openstack_compute_instance_v2.this[*].name
}

output "private_ips" {
  value = [for p in openstack_networking_port_v2.this : p.all_fixed_ips[0]]
}

output "floating_ips" {
  value = openstack_networking_floatingip_v2.this[*].address
}
