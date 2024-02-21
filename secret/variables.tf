variable "key" {
  type = string
}

variable "name" {
  type = string
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
