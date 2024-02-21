variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "verification_code" {
  type = string
}

variable "dkim" {
  type = list(string)
}

variable "ttl" {
  type = number
  default = 60
}
