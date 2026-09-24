locals {
  members = merge([
    for svc, cfg in var.services : {
      for i, addr in var.member_addresses : "${svc}-${i}" => {
        service = svc
        address = addr
        port    = cfg.member_port
      }
    }
  ]...)
}

resource "openstack_lb_loadbalancer_v2" "this" {
  name          = var.name
  vip_subnet_id = var.vip_subnet_id
}

resource "openstack_lb_listener_v2" "this" {
  for_each = var.services

  name            = "${var.name}-${each.key}-listener"
  loadbalancer_id = openstack_lb_loadbalancer_v2.this.id
  protocol        = each.value.protocol
  protocol_port   = each.value.listen_port
}

resource "openstack_lb_pool_v2" "this" {
  for_each = var.services

  name        = "${var.name}-${each.key}-pool"
  listener_id = openstack_lb_listener_v2.this[each.key].id
  protocol    = each.value.protocol
  lb_method   = each.value.lb_method
}

resource "openstack_lb_monitor_v2" "this" {
  for_each = var.services

  name        = "${var.name}-${each.key}-monitor"
  pool_id     = openstack_lb_pool_v2.this[each.key].id
  type        = each.value.monitor_type
  delay       = 5
  timeout     = 3
  max_retries = 3
  url_path    = each.value.monitor_type == "HTTP" ? each.value.monitor_url_path : null
}

resource "openstack_lb_member_v2" "this" {
  for_each = local.members

  pool_id       = openstack_lb_pool_v2.this[each.value.service].id
  address       = each.value.address
  protocol_port = each.value.port
  subnet_id     = var.member_subnet_id
}

resource "openstack_networking_floatingip_v2" "this" {
  count = var.assign_floating_ip ? 1 : 0
  pool  = var.floating_ip_pool
}

resource "openstack_networking_floatingip_associate_v2" "this" {
  count = var.assign_floating_ip ? 1 : 0

  floating_ip = openstack_networking_floatingip_v2.this[0].address
  port_id     = openstack_lb_loadbalancer_v2.this.vip_port_id
}
