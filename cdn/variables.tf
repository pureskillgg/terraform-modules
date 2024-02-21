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

variable "certificate_arn" {
  type = string
}

variable "bucket" {
  type = map(string)
}

variable "price_class" {
  type = string
  default = "PriceClass_200"
}

variable "default_ttl" {
  type = number
  default = 60
}

variable "min_ttl" {
  type = number
  default = 1
}

variable "max_ttl" {
  type = number
  default = 31556926
}

variable "default_root_object" {
  type = string
  default = null
}

variable "allowed_resources" {
  type = list(string)
  default = ["*"]
}
