variable "id" {
  type = string
  default = ""
}

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

variable "policy_documents" {
  type = list(string)
  default = []
}
