variable "name" {
  type = string
}

variable "parameters" {
  type = map(string)
}

variable "table_name" {
  type = string
}

variable "hash_key" {
  type = string
  default = "parameterSetName"
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
