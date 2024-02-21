variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomains" {
  type = list(string)
  default = ["*"]
}

variable "tags" {
  type = map(string)
  default = {}
}
