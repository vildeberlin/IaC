output "volume_ids" {
  value = { for k, v in openstack_blockstorage_volume_v3.this : k => v.id }
}

output "volume_names" {
  value = { for k, v in openstack_blockstorage_volume_v3.this : k => v.name }
}
