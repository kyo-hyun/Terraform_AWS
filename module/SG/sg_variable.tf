variable "name" {
    default = null
}

variable "vpcid" {
    default = null
}

variable "ingress_rule" {
    default = null
}

variable "egress_rule" {
    type = map(any)
    default = {}
}