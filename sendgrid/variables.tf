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

variable "domain" {
  type = string
}

variable "reverse_dns" {
  type = map(string)
  default = {}
}

variable "link_tracking_subdomains" {
  type = list(string)
  default = [
    "sg",
    "21587718"
  ]
}

variable "sendgrid_tracking_domain" {
  type = string
  default = "sendgrid.net"
}

variable "verification_domain" {
  type = string
}

variable "verification_code" {
  type = string
}

variable "dkim_selector_1" {
  type = string
  default = "s1"
}

variable "dkim_selector_2" {
  type = string
  default = "s2"
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

variable "price_class" {
  type = string
  default = "PriceClass_200"
}
