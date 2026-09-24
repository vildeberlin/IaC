
data "cloudinit_config" "userdata" {
  count         = var.template != "" ? 1 : 0
  gzip          = true
  base64_encode = true

  part {
    filename     = "userdata"
    content      = templatefile(var.template, {})
    content_type = "text/x-shellscript"
  }
}

#Get the manually created keypair
data "openstack_compute_keypair_v2" "my_keypair" {
  name = var.ssh_key_name
}

data "openstack_networking_network_v2" "ntnu_internal" {
  name = var.ntnu_internal_network
}

data "openstack_images_image_v2" "image" {
  name        = var.distro
  most_recent = true

  properties = {
    key = "value"
  }
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor
}

# Her lages vm-en
resource "openstack_compute_instance_v2" "vm" {
  name            = var.name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  key_pair        = data.openstack_compute_keypair_v2.my_keypair.name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name, "default"]
  user_data       = var.template == "" ? "" : data.cloudinit_config.userdata[0].rendered
  network {
    name = var.network
  }
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = var.secgroup_name
}