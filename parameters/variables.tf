variable "name" {
  type = string
}

variable "parameters" {
  type = map(string)
}

variable "type" {
  type = string
  default = "String"
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
