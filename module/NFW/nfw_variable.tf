variable "name" {
  type = string
  default = null
}

variable "vpc_id" {
  type = string
  default = null
}

variable "subnet_id" {
  type = list
  default = null
}

variable "stateless_rules" {
  type = list
  default = null
}

variable "stateful_rules" {
  type = list
  default = null
}