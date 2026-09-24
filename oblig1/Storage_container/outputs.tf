output "storage_container_name" {
  value = openstack_objectstorage_container_v1.this.name
}

output "storage_container_id" {
  value = openstack_objectstorage_container_v1.this.id
}
