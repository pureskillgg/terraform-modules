variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "verification_code" {
  type = string
}

variable "spf" {
  type = string
  default = "v=spf1 include:sendgrid.net ~all"
}

variable "create_spf" {
  type = bool
  default = true
}

variable "ttl" {
  type = number
  default = 60
}
