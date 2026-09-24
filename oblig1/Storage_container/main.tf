resource "openstack_objectstorage_container_v1" "this" {
  name = var.storage_container_name

  content_type = var.storage_container_content_type
  versioning   = var.storage_container_versioning
}