############ Provider / general ############
variable "os_cloud" {
  description = "Cloud name in clouds.yaml. Use null to rely on OS_* environment variables."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefix used for naming security groups (e.g. customer-env)."
  type        = string
  default     = "terranova-poc"
}

############ Network ############
variable "network_name" {
  description = "Name of the private network."
  type        = string
  default     = "terranova-poc-net"
}

variable "external_network_name" {
  description = "Name of the external/public network used by the router and for floating IPs."
  type        = string
}

variable "router_name" {
  description = "Name of the router."
  type        = string
  default     = "terranova-poc-router"
}

variable "subnets" {
  description = "The three tiers. Keys must be frontend, backend and database."
  type = map(object({
    name            = optional(string)
    cidr            = string
    enable_dhcp     = optional(bool, true)
    dns_nameservers = optional(list(string), ["1.1.1.1", "8.8.8.8"])
  }))
  default = {
    frontend = { cidr = "10.10.1.0/24" }
    backend  = { cidr = "10.10.2.0/24" }
    database = { cidr = "10.10.3.0/24" }
  }

  validation {
    condition     = toset(keys(var.subnets)) == toset(["frontend", "backend", "database"])
    error_message = "subnets must have exactly the keys frontend, backend and database."
  }
}

############ Security groups ############
variable "admin_cidr" {
  description = "CIDR allowed to SSH into the VMs (use your own IP/32 outside the PoC)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "security_groups" {
  description = "Overrides/adds security groups by key on top of the defaults ssh, web and db. null = defaults only."
  type = map(object({
    description = optional(string, "")
    rules = list(object({
      direction        = optional(string, "ingress")
      protocol         = optional(string, "tcp")
      port_min         = optional(number)
      port_max         = optional(number)
      remote_ip_prefix = optional(string, "0.0.0.0/0")
    }))
  }))
  default = null
}

############ SSH key ############
variable "keypair_name" {
  description = "Name of the OpenStack key pair to create."
  type        = string
  default     = "terranova-poc-key"
}

variable "ssh_public_key_path" {
  description = "Path to the public SSH key to upload."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

############ Frontend VMs ############
variable "frontend_name" {
  description = "Name (prefix) of the frontend VMs."
  type        = string
  default     = "terranova-poc-web"
}

variable "frontend_instance_count" {
  type    = number
  default = 2
}

variable "frontend_image_name" {
  type    = string
  default = "ubuntu-22.04"
}

variable "frontend_flavor_name" {
  type    = string
  default = "m1.small"
}

variable "frontend_assign_floating_ip" {
  description = "Give frontend VMs a floating IP (also acts as SSH jump host)."
  type        = bool
  default     = true
}

variable "frontend_cloud_init_template" {
  description = "Path to the cloud-init template for frontend VMs."
  type        = string
  default     = "cloud-init/frontend.yaml.tftpl"
}

variable "frontend_volume_keys" {
  description = "Keys from var.volumes to attach to frontend VMs (i-th key -> i-th VM)."
  type        = list(string)
  default     = []
}

############ DB VMs ############
variable "db_name_prefix" {
  description = "Name (prefix) of the database VMs."
  type        = string
  default     = "terranova-poc-db"
}

variable "db_instance_count" {
  type    = number
  default = 1
}

variable "db_image_name" {
  type    = string
  default = "ubuntu-22.04"
}

variable "db_flavor_name" {
  type    = string
  default = "m1.small"
}

variable "db_cloud_init_template" {
  description = "Path to the cloud-init template for DB VMs."
  type        = string
  default     = "cloud-init/db.yaml.tftpl"
}

variable "db_volume_keys" {
  description = "Keys from var.volumes to attach to DB VMs (i-th key -> i-th VM)."
  type        = list(string)
  default     = ["dbdata"]
}

variable "db_database_name" {
  type    = string
  default = "appdb"
}

variable "db_user" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  description = "Database password (injected into cloud-init; use a secret store for anything but a PoC)."
  type        = string
  sensitive   = true
}

############ Persistent storage / containers ############
variable "volumes" {
  description = "Cinder volumes to create, keyed by logical name."
  type = map(object({
    name        = string
    size_gb     = number
    volume_type = optional(string)
    description = optional(string, "")
  }))
  default = {
    dbdata = { name = "terranova-poc-dbdata", size_gb = 10 }
  }
}

variable "containers" {
  description = "Swift object storage containers, keyed by logical name."
  type = map(object({
    name           = string
    container_read = optional(string)
    metadata       = optional(map(string), {})
  }))
  default = {
    assets = { name = "terranova-poc-assets" }
  }
}

############ Load balancer ############
variable "enable_load_balancer" {
  description = "Flag: create a load balancer in front of the frontend VMs."
  type        = bool
  default     = true
}

variable "lb_name" {
  type    = string
  default = "terranova-poc-lb"
}

variable "lb_assign_floating_ip" {
  type    = bool
  default = true
}

variable "lb_services" {
  description = "Services to load balance (one listener + pool + monitor each)."
  type = map(object({
    protocol         = string # HTTP, HTTPS, TCP ...
    listen_port      = number
    member_port      = number
    lb_method        = optional(string, "ROUND_ROBIN")
    monitor_type     = optional(string, "HTTP")
    monitor_url_path = optional(string, "/health")
  }))
  default = {
    http = { protocol = "HTTP", listen_port = 80, member_port = 80 }
  }
}
