variable "name_prefix" {
  type = string
}

variable "network_name" {
  type = string
}

variable "external_network_name" {
  type = string
}

variable "router_name" {
  type = string
}

variable "subnets" {
  type = map(object({
    name            = optional(string)
    cidr            = string
    enable_dhcp     = optional(bool, true)
    dns_nameservers = optional(list(string), [])
  }))
}

variable "security_groups" {
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
}
