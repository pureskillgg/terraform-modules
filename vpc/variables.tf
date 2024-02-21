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

variable "region" {
  type = string
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

variable "cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "use_ec2_nat" {
  type = bool
  default = false
}

variable "nat_instance_type" {
  type = string
  default = "t3a.micro"
}
