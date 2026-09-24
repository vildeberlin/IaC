resource "openstack_blockstorage_volume_v3" "vol" {
  name = var.name
  size = var.size_gb
}

resource "openstack_compute_volume_attach_v2" "attach" {
  count       = var.attach_storage_to_vm ? 1 : 0
  
  instance_id = var.instance_id
  volume_id   = openstack_blockstorage_volume_v3.vol.id
}