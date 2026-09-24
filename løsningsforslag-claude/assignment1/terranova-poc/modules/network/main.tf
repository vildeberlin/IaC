data "openstack_networking_network_v2" "external" {
  name     = var.external_network_name
  external = true
}

resource "openstack_networking_network_v2" "this" {
  name           = var.network_name
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "this" {
  for_each = var.subnets

  name            = coalesce(each.value.name, "${var.network_name}-${each.key}")
  network_id      = openstack_networking_network_v2.this.id
  cidr            = each.value.cidr
  ip_version      = 4
  enable_dhcp     = each.value.enable_dhcp
  dns_nameservers = each.value.dns_nameservers
}

resource "openstack_networking_router_v2" "this" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource "openstack_networking_router_interface_v2" "this" {
  for_each = openstack_networking_subnet_v2.this

  router_id = openstack_networking_router_v2.this.id
  subnet_id = each.value.id
}

resource "openstack_networking_secgroup_v2" "this" {
  for_each = var.security_groups

  name        = "${var.name_prefix}-${each.key}"
  description = each.value.description
}

locals {
  rules = merge([
    for sg, cfg in var.security_groups : {
      for i, r in cfg.rules : "${sg}-${i}" => merge(r, { sg = sg })
    }
  ]...)
}

resource "openstack_networking_secgroup_rule_v2" "this" {
  for_each = local.rules

  security_group_id = openstack_networking_secgroup_v2.this[each.value.sg].id
  direction         = each.value.direction
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  port_range_min    = each.value.port_min
  port_range_max    = each.value.port_max
  remote_ip_prefix  = each.value.remote_ip_prefix
}
