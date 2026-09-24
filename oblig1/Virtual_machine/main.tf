

  data "openstack_compute_keypair_v2" "my_keypair" {
    name = var.ssh_key_name
  }

  //instance/vm
  /*Generisk, samme burkes til å lag ebåde frontend og DB.check "name" {
    Kalles to ganger fra root. 
  }*/

  resource "openstack_compute_instance_v2" "frontend" {
    name            = var.name
    image_id        = var.vm-image_id
    flavor_name     = var.vm-flavor_name
    key_pair        = var.keypair_name
    security_groups = var.security_group_ids


    network {
          uuid = var.network_id
    }
  }

  resource "openstack_compute_volume_attach_v2" "attach" {
    count       = var.attach_volume_id != null ? 1 : 0 //betyr: "lag denne koblingen bare hvis noen faktisk sendte inn et volum-ID"
    instance_id = openstack_compute_instance_v2.vm.id
    volume_id   = var.attach_volume_id
  }


