// Skriver ut id 
output "volume_id" {
  description = "ID til volumet"
  value = openstack_blockstorage_volume_v3.vol.id
}

// Skriver ut navn
output "volume_name" {
  description = "Navn til volumet"
  value = openstack_blockstorage_volume_v3.vol.name
}