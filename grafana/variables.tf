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

variable "region" {
  type = string
}
