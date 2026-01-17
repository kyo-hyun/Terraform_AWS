output "firewall_arn" {
  description = "The ARN of the Network Firewall"
  value       = aws_networkfirewall_firewall.this.arn
}

output "firewall_policy_arn" {
  description = "The ARN of the Network Firewall policy"
  value       = aws_networkfirewall_firewall_policy.this.arn
}

output "rule_group_arn" {
  description = "The ARN of the rule group"
  value       = aws_networkfirewall_rule_group.pass_all.arn
}
