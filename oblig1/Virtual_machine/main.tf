
data "cloudinit_config" "userdata" {
    count         = var.template != "" ? 1 : 0
    gzip          = true
    base64_encode = true
  
    part {
      filename     = "cloud-config.yaml"
      content      = templatefile(var.template, {})
      content_type = "text/cloud-config"  
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
/*
  properties = {
    key = "value"
  }*/
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor
}


 # Port i riktig subnett (frontend eller database)
  resource "openstack_networking_port_v2" "port" {
    name               = "${var.name}-port"
    security_group_ids = [openstack_networking_secgroup_v2.secgroup.id]

    fixed_ip {
      subnet_id = var.subnet_id
    } 
  }
  
  resource "openstack_compute_instance_v2" "vm" {
    name        = var.name
    image_id    = data.openstack_images_image_v2.image.id
    flavor_id   = data.openstack_compute_flavor_v2.flavor.id
    key_pair    = data.openstack_compute_keypair_v2.my_keypair.name
    user_data   = var.template == "" ? null : data.cloudinit_config.userdata[0].rendered

    network {
      port = openstack_networking_port_v2.port.id
    }
  }

/*
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
*/
