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

variable "organization" {
  type = string
}

variable "team" {
  type = string
}

variable "platform" {
  type = string
}
