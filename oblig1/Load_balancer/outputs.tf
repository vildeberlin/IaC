output "name" {
  value = openstack_lb_loadbalancer_v2.lb.vip_address
}