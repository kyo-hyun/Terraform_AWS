variable "name" {
  description = "The name of the firewall"
  type        = string
}

variable "policy_name" {
  description = "The name of the firewall policy"
  type        = string
}

variable "rule_group_name" {
  description = "The name of the rule group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnets_ids" {
  description = "A list of subnet IDs to associate with the Network Firewall"
  type        = list(string)
}
