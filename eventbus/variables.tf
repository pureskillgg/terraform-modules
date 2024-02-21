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

variable "account_id" {
  type = string
}

variable "log_retention_in_days" {
  type = number
  default = 3
}
