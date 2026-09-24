variable "name" {
  description = "Navnet på min persistant storage"
}

variable "size_gb" {
  description = "Størrelsen på persistant storage"
  type = number
  default = 20
}