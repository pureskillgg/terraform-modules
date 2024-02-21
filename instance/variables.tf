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

variable "policy" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "ami" {
  type = string
}

variable "instance_count" {
  type = number
  default = 1
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "volume_size" {
  type = number
  default = 8
}

variable "user_data" {
  type = string
  default = ""
}

variable "source_dest_check" {
  type = bool
  default = true
}
