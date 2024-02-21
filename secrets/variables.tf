variable "name" {
  type = string
}

variable "secrets" {
  type = map(string)
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
