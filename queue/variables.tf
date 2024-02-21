variable "name" {
  type = string
}

variable "id" {
  type = string
  default = 0
}

variable "fifo_queue" {
  type = bool
  default = false
}

variable "max_receive_count" {
  type = number
  default = 5
}

variable "message_retention_seconds" {
  type = number
  default = 1209600
}

variable "visibility_timeout_seconds" {
  type = number
  default = 180
}

variable "receive_wait_time_seconds" {
  type = number
  default = 20
}

variable "delay_seconds" {
  type = number
  default = 0
}

variable "deadletter_message_retention_seconds" {
  type = number
  default = 1209600
}

variable "meta" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
