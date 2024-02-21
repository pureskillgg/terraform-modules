variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "log_group" {
  type = string
}

variable "log_level" {
  type = string
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "cpu" {
  type = number
  default = 256
}

variable "uid" {
  type = number
  default = 10000
}

variable "gid" {
  type = number
  default = 10000
}

variable "memory" {
  type = number
  default = 512
}

variable "stop_timeout" {
  type = number
  default = 60
}

variable "health_check_cmd" {
  type = string
  default = "true"
}

variable "xray_enabled" {
  type = bool
  default = false
}

variable "environment" {
  type = list(any)
  default = []
}

variable "secrets" {
  type = list(any)
  default = []
}
