variable "name" {
  type = string
}

variable "id" {
  type = string
  default = 0
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "zone_id" {
  type = string
}

variable "dkim" {
  type = string
}

variable "domain" {
  type = string
}

variable "link_tracking_domain" {
  type = string
}

variable "customerio_tracking_domain" {
  type = string
  default = "track.customer.io"
}

variable "dkim_prefix" {
  type = string
  default = "krs"
}

variable "spf" {
  type = string
  default = "v=spf1 include:mailgun.org ~all"
}

variable "create_spf" {
  type = bool
  default = true
}

variable "mx_priority" {
  type = string
  default = "10"
}

variable "ttl" {
  type = string
  default = 60
}

variable "price_class" {
  type = string
  default = "PriceClass_200"
}
