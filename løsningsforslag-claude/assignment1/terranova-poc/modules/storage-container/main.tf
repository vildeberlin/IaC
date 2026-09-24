resource "openstack_objectstorage_container_v1" "this" {
  for_each = var.containers

  name           = each.value.name
  container_read = each.value.container_read
  metadata       = each.value.metadata
}
