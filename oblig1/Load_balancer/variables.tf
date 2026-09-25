output "lb_id" {
    description = "ID til lastbalansereren (null hvis av)"
  }
  
  output "lb_vip_address" {
    description = "Intern VIP-adresse (null hvis av)"
    value       = one(openstack_lb_loadbalancer_v2.lb[*].vip_address)
  }
  
  output "lb_floating_ip" {
    description = "Ekstern IP til lastbalansereren (null hvis av)"
    value       = one(openstack_networking_floatingip_v2.lb[*].address)
  }
  
  output "lb_endpoint" {
    description = "URL til tjenesten bak lastbalansereren (null hvis av)"
    value       = var.flag ? "${lower(var.protocol)}://${openstack_networking_floatingip_v2.lb[0].address}:${var.protocol_port}" : null
  }