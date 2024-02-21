variable "first_name" {
  type = string
}

variable "last_name" {
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

variable "policy_documents" {
  type = list(string)
  default = []
}

variable "groups" {
  type = list(string)
  default = []
}
