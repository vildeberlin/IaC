variable "name" {
  type = string
}

variable "vip_subnet_id" {
  type = string
}

variable "member_subnet_id" {
  type = string
}

variable "member_addresses" {
  description = "Private IPs of the backend members."
  type        = list(string)
}

variable "services" {
  type = map(object({
    protocol         = string
    listen_port      = number
    member_port      = number
    lb_method        = optional(string, "ROUND_ROBIN")
    monitor_type     = optional(string, "HTTP")
    monitor_url_path = optional(string, "/")
  }))
}

variable "assign_floating_ip" {
  type    = bool
  default = true
}

variable "floating_ip_pool" {
  type    = string
  default = null
}
