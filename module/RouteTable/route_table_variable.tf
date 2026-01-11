variable "name" {
    default = null
}

variable "vpc_id" {
    default = null
}

variable "routes" {
    type    = list
    default = null
}

variable "subnet_ids" {
    type    = map(string)
    default = null
}