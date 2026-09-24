output "container_names" {
  value = { for k, c in openstack_objectstorage_container_v1.this : k => c.name }
}
