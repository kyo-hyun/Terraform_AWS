variable "name" {
    default = null
}

variable "eks_version" {
    default = null
}

variable "subnets" {
    default = null
}

variable "api_access" {
    type    = object({
        public_access  = bool
        private_access = bool
    })
    default = null
}

variable "access_user" {
    default = null
}

variable "user_policy" {
    default = null
}

variable "cluster_role" {
    default = null
}

variable "node_group" {
    default = null
}
