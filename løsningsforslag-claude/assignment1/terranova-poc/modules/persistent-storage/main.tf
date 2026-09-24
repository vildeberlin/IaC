resource "openstack_blockstorage_volume_v3" "this" {
  for_each = var.volumes

  name        = each.value.name
  size        = each.value.size_gb
  volume_type = each.value.volume_type
  description = each.value.description
}
