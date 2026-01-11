variable "name" {
    default = null
}

variable "ami" {
    default = null
}

variable "type" {
    default = null
}

variable "subnet" {
    default = null
}

variable "private_ip" {
    default = null
}

variable "role" {
    default = null
}

variable "root_ebs" {
    default = null
}

variable "add_ebs" {
    default = null
}

variable "eip" {
    default = null
}

variable "eip_name" {
    default = null
}

variable "sg_id" {
    type    = list(string)
    default = null
}

variable "user_data" {
    default = null
}

variable "availability_zone" {
    default = null
}