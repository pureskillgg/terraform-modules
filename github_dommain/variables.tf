variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "organization" {
  type = string
}

variable "pages_subdomains" {
  type = list(string)
  default = []
}

variable "verification_code" {
  type = string
}

variable "pages_verification_code" {
  type = string
}

variable "ttl" {
  type = number
  default = 60
}
