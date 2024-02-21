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

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "queue" {
  type = map(string)
}

variable "enabled" {
  type = bool
  default = true
}

variable "min_capacity" {
  type = number
  default = 1
}

variable "max_capacity" {
  type = number
  default = 10
}
