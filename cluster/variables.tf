variable "id" {
  type = number
  default = 0
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

variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "instance_type" {
  type = string
  default = "t4g.micro"
}

variable "instance_architecture" {
  type = string
  default = "arm64"
}

variable "min_size" {
  type = number
  default = 0
}

variable "max_size" {
  type = number
  default = 1
}

variable "cluster_max_size" {
  type = number
  default = 1
}

variable "wait_for_capacity_timeout" {
  type = number
  default = 0
}

variable "scaling_step_size" {
  type = number
  default = 1
}
