variable "amazon_side_asn" {
    type    = number
    default = null
}

variable "vpc_connections" {
    default = null
}

variable "route_table" {
    default = null
}

variable "name" {
    type    = string
    default = null
}

variable "tags" {
    type    = map(string)
    default = null
}