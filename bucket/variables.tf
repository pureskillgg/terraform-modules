variable "name" {
  type = string
}

variable "id" {
  type = string
  default = 0
}

variable "transfer_acceleration_enabled" {
  type = bool
  default = false
}

variable "versioning_enabled" {
  type = bool
  default = true
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "cors_allowed_headers" {
  type = list(string)
  default = []
}

variable "cors_allowed_methods" {
  type = list(string)
  default = ["HEAD"]
}

variable "cors_allowed_origins" {
  type = list(string)
  default = ["https://example.com"]
}

variable "cors_expose_headers" {
  type = list(string)
  default = [
    "Content-Length",
    "Content-Type",
    "Connection",
    "Date",
    "ETag"
  ]
}

variable "cors_max_age_seconds" {
  type = number
  default = 0
}

variable "infrequent_access_transition_enabled" {
  type = bool
  default = true
}

variable "infrequent_access_transition_days" {
  type = number
  default = 30
}

variable "noncurrent_version_expiration_enabled" {
  type = bool
  default = true
}

variable "noncurrent_version_expiration_days" {
  type = number
  default = 1
}

variable "expiration_enabled" {
  type = bool
  default = false
}

variable "expiration_days" {
  type = number
  default = 7
}
