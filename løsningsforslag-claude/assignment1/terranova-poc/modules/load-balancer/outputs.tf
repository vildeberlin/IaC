output "vip_address" {
  value = openstack_lb_loadbalancer_v2.this.vip_address
}

output "floating_ip" {
  value = one(openstack_networking_floatingip_v2.this[*].address)
}

output "endpoints" {
  description = "Endpoint per service."
  value = {
    for k, s in var.services :
    k => "${lower(s.protocol)}://${coalesce(one(openstack_networking_floatingip_v2.this[*].address), openstack_lb_loadbalancer_v2.this.vip_address)}:${s.listen_port}"
  }
}
