resource "openstack_lb_loadbalancer_v2" "lb" {
  count = var.flag ? 1 : 0

  name          = "lb"
  vip_subnet_id = openstack_networking_subnet_v2.network.id
}

resource "openstack_lb_listener_v2" "http" {
  protocol        = var.protocol
  protocol_port   = var.protocol_port
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

resource "openstack_lb_pool_v2" "pool" {
  protocol    = var.protocol
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.http.id
}

resource "openstack_lb_member_v2" "frontend1" {
  pool_id       = openstack_lb_pool_v2.pool.id
  address       = var.member_address
  protocol_port = var.protocol_port
  subnet_id     = var.member_subnet_id
}

resource "openstack_networking_floatingip_v2" "lb" {
    count   = var.flag ? 1 : 0
    pool    = var.external_network_name
    port_id = openstack_lb_loadbalancer_v2.lb[0].vip_port_id
  }