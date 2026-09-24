variable "volumes" {
  description = "Cinder volumes keyed by logical name."
  type = map(object({
    name        = string
    size_gb     = number
    volume_type = optional(string)
    description = optional(string, "")
  }))
}
