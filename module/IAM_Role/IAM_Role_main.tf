# AWS policy 불러오기기
data "aws_iam_policy" "policy" {
  for_each = {for policy in var.policy : policy.policy_name => policy if policy.custom_policy == false }
  name     = each.value.policy
}

resource "aws_iam_role" "test_role" {
  name = var.name
  assume_role_policy = jsonencode(var.trusted_entities)
}

resource "aws_iam_role_policy_attachment" "regular-policy-attach" {
  for_each   = data.aws_iam_policy.policy
  role       = aws_iam_role.test_role.name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "custom-policy-attach" {
  for_each   = {for policy in var.policy : policy.policy_name => policy if policy.custom_policy == true}
  role       = aws_iam_role.test_role.name
  policy_arn = var.policy
}

resource "aws_iam_instance_profile" "test_profile" {
  name = var.name
  role = aws_iam_role.test_role.name
}