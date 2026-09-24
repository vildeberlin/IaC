data "openstack_images_image_v2" "this" {
  name        = var.image_name
  most_recent = true
}

data "openstack_compute_flavor_v2" "this" {
  name = var.flavor_name
}

resource "openstack_networking_port_v2" "this" {
  count = var.instance_count

  name               = "${var.name}-${count.index + 1}-port"
  network_id         = var.network_id
  admin_state_up     = true
  security_group_ids = var.security_group_ids

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

resource "openstack_compute_instance_v2" "this" {
  count = var.instance_count

  name      = "${var.name}-${count.index + 1}"
  image_id  = data.openstack_images_image_v2.this.id
  flavor_id = data.openstack_compute_flavor_v2.this.id
  key_pair  = var.key_pair
  user_data = var.user_data

  network {
    port = openstack_networking_port_v2.this[count.index].id
  }
}

resource "openstack_networking_floatingip_v2" "this" {
  count = var.assign_floating_ip ? var.instance_count : 0
  pool  = var.floating_ip_pool
}

resource "openstack_networking_floatingip_associate_v2" "this" {
  count = var.assign_floating_ip ? var.instance_count : 0

  floating_ip = openstack_networking_floatingip_v2.this[count.index].address
  port_id     = openstack_networking_port_v2.this[count.index].id
}

resource "openstack_compute_volume_attach_v2" "this" {
  count = length(var.volume_ids)

  instance_id = openstack_compute_instance_v2.this[count.index].id
  volume_id   = var.volume_ids[count.index]
}
