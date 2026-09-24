resource "openstack_blockstorage_volume_v3" "vol" {
  name = var.name
  size = var.size_gb
}

resource "openstack_compute_volume_attach_v2" "attach" {
  instance_id = openstack_compute_instance_v2.vm.id
  volume_id = openstack_blockstorage_volume_v3.vol.id
}