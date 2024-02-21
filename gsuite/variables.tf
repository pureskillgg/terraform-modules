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
  type = string
}

variable "ttl" {
  type = number
  default = 60
}

variable "spf" {
  type = string
  default = "v=spf1 include:_spf.google.com ~all"
}

variable "dkim_prefix" {
  type = string
  default = "google"
}

variable "dmarc_policy" {
  type = string
  default = "none"
}
