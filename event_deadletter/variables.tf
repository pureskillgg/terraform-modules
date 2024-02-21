variable "rule_name" {
  type = string
}

variable "name" {
  type = string
}

variable "id" {
  type = string
  default = 0
}

variable "eventbus" {
  type = map(string)
}

variable "message_retention_seconds" {
  type = number
  default = 1209600
}

variable "visibility_timeout_seconds" {
  type = number
  default = 180
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
