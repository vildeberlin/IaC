resource "openstack_lb_loadbalancer_v2" "lb" {
  name          = "lb"
  vip_subnet_id = openstack_networking_subnet_v2.network.id
}
