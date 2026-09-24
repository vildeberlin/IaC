variable "lb_name" {
  type = string
}

variable "protocol" {
  type = string
  default = "HTTP"
}

variable "protocol_port" {
  type = number
  default = 80
}

variable "flag" {
  type = bool
  default = true
}