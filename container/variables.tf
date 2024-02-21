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

variable "cluster_id" {
  type = string
}

variable "capacity_provider_name" {
  type = string
}

variable "name_suffix" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "execution_role_arn" {
  type = string
}

variable "policy" {
  type = string
}

variable "container_definitions" {
  type = list(string)
}

variable "log_group_name" {
  type = string
}

variable "cpu" {
  type = number
  default = 256
}

variable "memory" {
  type = number
  default = 512
}

variable "network_mode" {
  type = string
  default = "awsvpc"
}

variable "log_retention_in_days" {
  type = number
  default = 7
}

variable "desired_count" {
  type = number
  default = null
}
