output "get_nfw_endpoint_id" {
  value = aws_networkfirewall_firewall.nfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id
}