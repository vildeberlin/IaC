####
# Data sources to fetch existing resources in OpenStack

#Get the external network ID
data "openstack_networking_network_v2" "ntnu_internal" {
  name = var.ntnu_internal_network
}