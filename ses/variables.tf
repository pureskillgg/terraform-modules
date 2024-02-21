variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "noreply" {
  type = string
  default = "no-reply"
}

variable "mail_from_subdomain" {
  type = string
  default = "bounce"
}

variable "spf" {
  type = string
  default = "v=spf1 include:amazonses.com ~all"
}

variable "create_spf" {
  type = bool
  default = true
}

variable "mx_priority" {
  type = number
  default = 10
}

variable "ttl" {
  type = number
  default = 60
}
