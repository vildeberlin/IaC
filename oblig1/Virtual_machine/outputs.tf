output "vm_id" {
    description = "ID til VM-en"
    value       = openstack_compute_instance_v2.vm.id
  }

  
output "vm_ip" {
    description = "Intern IPv4-adresse til VM-en"
    value       = openstack_compute_instance_v2.vm.access_ip_v4
  }

/*
output "openstack_compute_instance_v2" {
  value = openstack_compute_instance_v2.vm.id
}

output "openstack_compute_instance_v2" {
  value = openstack_compute_instance_v2.vm.IPv4
}*/