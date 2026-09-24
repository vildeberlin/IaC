variable "containers" {
  description = "Swift containers keyed by logical name."
  type = map(object({
    name           = string
    container_read = optional(string)
    metadata       = optional(map(string), {})
  }))
}
