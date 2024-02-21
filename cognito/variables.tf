variable "name" {
  type = string
}

variable "id" {
  type = string
  default = 0
}

variable "domain" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "from_email" {
  type = string
}

variable "reply_to_email" {
  type = string
}

variable "ses_email_identity_arn" {
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
