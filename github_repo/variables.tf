variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "organization" {
  type = string
}

variable "homepage_url" {
  type = string
  default = null
}

variable "pages_domain" {
  type = string
  default = null
}

variable "pages_cname" {
  type = string
  default = null
}

variable "visibility" {
  type = string
  default = "private"
}

variable "topics" {
  type = list(string)
  default = []
}

variable "pages_enabled" {
  type = string
  default = false
}

variable "pages_branch" {
  type = string
  default = "gh-pages"
}

variable "pages_path" {
  type = string
  default = "/"
}

variable "allow_merge_commit" {
  type = bool
  default = null
}

variable "allow_squash_merge" {
  type = bool
  default = null
}

variable "allow_rebase_merge" {
  type = bool
  default = null
}

variable "teams" {
  type = map(
    object({
      id = string
      permission = string
    })
  )
  default = {}
}

variable "collaborators" {
  type = map(
    object({
      permission = string
    })
  )
  default = {}
}
