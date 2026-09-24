output "network_id" {
  value = module.network.network_id
}

output "subnet_ids" {
  description = "Subnet IDs per tier."
  value       = module.network.subnet_ids
}

output "frontend_vm_ids" {
  value = module.frontend_vm.ids
}

output "frontend_private_ips" {
  value = module.frontend_vm.private_ips
}

output "frontend_floating_ips" {
  value = module.frontend_vm.floating_ips
}

output "db_vm_ids" {
  value = module.db_vm.ids
}

output "db_private_ips" {
  value = module.db_vm.private_ips
}

output "lb_endpoints" {
  description = "Endpoints per load-balanced service (null if LB disabled)."
  value       = one(module.load_balancer[*].endpoints)
}

output "volume_ids" {
  value = module.persistent_storage.volume_ids
}

output "volume_names" {
  value = module.persistent_storage.volume_names
}

output "container_names" {
  value = module.storage_container.container_names
}

output "ssh_hint" {
  description = "How to reach the DB VM through a frontend VM (jump host)."
  value       = var.frontend_assign_floating_ip ? "ssh -J ubuntu@${module.frontend_vm.floating_ips[0]} ubuntu@${module.db_vm.private_ips[0]}" : null
}
