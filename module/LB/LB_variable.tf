variable "name" {
    default = null
}

variable "internal" {
    default = null
}

variable "load_balancer_type" {
    default = null
}

variable "certificate_arn" {
    default = null
}

variable "security_groups" {
    type    = list(string)
    default = null
}

variable "subnets" {
    type    = list(string)
    default = null
}

variable "alb_listener" {
    default = null
}

variable "default_target_group" {
    type    = list
    default = null
}

variable "rule" {
    default = null
}

variable "nlb_listener" {
    type = list
    default = null
}