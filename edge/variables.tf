variable "id" {
  type = string
}

variable "name" {
  type = string
}

variable "meta" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}

variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "gateway_domain" {
  type = string
  default = null
}

variable "price_class" {
  type = string
  default = "PriceClass_200"
}

variable "default_ttl" {
  type = number
  default = 5
}

variable "min_ttl" {
  type = number
  default = 0
}

variable "max_ttl" {
  type = number
  default = 5
}
