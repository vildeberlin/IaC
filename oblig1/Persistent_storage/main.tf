resource "openstack_blockstorage_volume_v3" "vol" {
  name = var.name
  size = var.size_gb
}
