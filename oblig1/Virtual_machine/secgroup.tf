# Én regel per oppføring i var.security_rules
resource "openstack_networking_secgroup_rule_v2" "rules" {
    for_each = var.security_rules

    direction         = "ingress"
    ethertype         = "IPv4"
    protocol          = each.value.protocol
    port_range_min    = each.value.port
    port_range_max    = each.value.port
    remote_ip_prefix  = each.value.cidr
    security_group_id = openstack_networking_secgroup_v2.secgroup.id
}