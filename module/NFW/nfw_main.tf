# --------------------------------------------------------------------------------------------------
# Create Network Firewall Rule Group
# --------------------------------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "pass_all" {
  name     = var.rule_group_name
  capacity = 100
  type     = "STATELESS"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              sources = [
                { address_definition = "0.0.0.0/0" }
              ]
              destinations = [
                { address_definition = "0.0.0.0/0" }
              ]
              source_ports = [
                { from_port = 0, to_port = 65535 }
              ]
              destination_ports = [
                { from_port = 0, to_port = 65535 }
              ]
              protocols = [6, 17] # TCP (6), UDP (17)
            }
          }
        }
      }
    }
  }

  tags = {
    Name = var.rule_group_name
  }
}

# --------------------------------------------------------------------------------------------------
# Create Network Firewall Policy
# --------------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "this" {
  name = var.policy_name

  firewall_policy {
    stateless_default_actions          = ["aws:drop"]
    stateless_fragment_default_actions = ["aws:drop"]
    stateless_rule_group_reference {
      priority     = 10
      resource_arn = aws_networkfirewall_rule_group.pass_all.arn
    }
  }

  tags = {
    Name = var.policy_name
  }
}

# --------------------------------------------------------------------------------------------------
# Create Network Firewall
# --------------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall" "this" {
  name                = var.name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
  vpc_id              = var.vpc_id
  delete_protection   = false
  subnet_change_protection = false

  dynamic "subnet_mapping" {
    for_each = toset(var.subnets_ids)
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name = var.name
  }
}
