variable "function_name" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "handler" {
  type    = string
  default = "handler.handler"
}

variable "runtime" {
  type    = string
  default = "python3.12"
}

variable "role_arn" {
  type = string
}