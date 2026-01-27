resource "aws_networkfirewall_firewall" "nfw" {
  name                = var.name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.nfw_policy.arn
  vpc_id              = var.vpc_id

  subnet_mapping {
    subnet_id = var.subnet_id
  }

  delete_protection                 = false
  subnet_change_protection          = false
  firewall_policy_change_protection = false
}

resource "aws_networkfirewall_rule_group" "stateless_allow_all" {
  count    = var.stateless_rules != null ? 1 : 0
  name     = "stateless-allow-all"
  capacity = 100
  type     = "STATELESS"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        
      dynamic "stateless_rule" {
          for_each = var.stateless_rules
          content {
            priority = stateless_rule.value.priority
            rule_definition {
              actions = [stateless_rule.value.action]
              match_attributes {
                source {
                  address_definition = stateless_rule.value.src
                }
                destination {
                  address_definition = stateless_rule.value.dst
                }
                protocols = stateless_rule.value.protocol

                source_port {
                  from_port = stateless_rule.value.src_port.from
                  to_port   = stateless_rule.value.src_port.to
                }
                destination_port {
                  from_port = stateless_rule.value.dst_port.from
                  to_port   = stateless_rule.value.dst_port.to
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_networkfirewall_rule_group" "stateful_rules" {
  count    = var.stateful_rules != null ? 1 : 0
  name     = "stateful-rule-group"
  capacity = 500
  type     = "STATEFUL"

  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = ["10.0.0.0/8"]
        }
      }
    }

    rules_source {
      dynamic "stateful_rule" {
        for_each = var.stateful_rules
        content {
          action = stateful_rule.value.action
          header {
            protocol         = stateful_rule.value.protocol
            source           = stateful_rule.value.src
            source_port      = stateful_rule.value.src_port
            destination      = stateful_rule.value.dst
            destination_port = stateful_rule.value.dst_port
            direction        = stateful_rule.value.direction
          }
          rule_option {
            keyword  = "sid"
            settings = [tostring(index(var.stateful_rules, stateful_rule.value) + 1)]
          }
          rule_option {
            keyword  = "msg"
            settings = ["\"${stateful_rule.value.description}\""]
          }
        }
      }
    }
  }
}

resource "aws_networkfirewall_firewall_policy" "nfw_policy" {
  name = "basic-nfw-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateless_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.stateless_allow_all[0].arn
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.stateful_rules[0].arn
    }
  }
}