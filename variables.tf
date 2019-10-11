variable "env" {}

variable "aws" {
  type    = any
  default = {}
}

variable "iam_roles" {
  type = any
  default = []
}
