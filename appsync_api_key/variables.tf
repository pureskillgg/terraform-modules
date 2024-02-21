variable "name" {
  type = string
}

variable "appsync" {
  type = map(string)
}

variable "expiry_months" {
  type = number
  default = 11
}

variable "rotation_months" {
  type = number
  default = 10
}
