resource "openstack_networking_secgroup_rule_v2" "rules" {
  for_each = var.security_rules

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = var.value.protocol
  port_range_min    = var.value.port
  port_range_max    = var.value.port
  remote_ip_prefix  = var.value.cidr
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}