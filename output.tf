# Nettverk
  output "network_name" {
    value = module.Network.network_name
  }

  output "subnet_ids" {
    value = module.Network.subnet_ids
  }

  # VM-er
  output "vm_ids" {
    value = {
      frontend = module.vm_frontend.vm_id
      db       = module.vm_db.vm_id
    }
  }

  output "vm_ips" {
    value = {
      frontend = module.vm_frontend.vm_ip
      db       = module.vm_db.vm_ip
    }
  }

  # Lastbalanserer
  output "lb_endpoint" {
    description = "Koble til tjenesten her (null hvis LB er av)"
    value       = module.Load_balancer.lb_endpoint
  }

  # Persistent lagring
  output "volume" {
    value = {
      id   = module.Persistent_storage.volume_id
      name = module.Persistent_storage.volume_name
    }
  }

  # Storage container
  output "storage_container_name" {
    value = module.object_storage.storage_container_name
  }
