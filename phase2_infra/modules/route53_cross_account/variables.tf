variable "zone_id" {
  type = string
}

variable "records" {
  type = map(object({
    name = string
    type = string
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }))
    ttl     = optional(number)
    records = optional(list(string))
  }))
}