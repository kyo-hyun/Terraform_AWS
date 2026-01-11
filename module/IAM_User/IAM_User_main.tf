# user 생성
resource "aws_iam_user" "user" {
  name = var.name
  path = var.path != null ? var.path : null
  tags = var.tags
}

# AWS policy 불러오기기
data "aws_iam_policy" "policy" {
  for_each = {for policy in var.policy : policy.policy_name => policy if policy.custom_policy == false }
  name     = each.value.policy
}

# aws policy 붙이기 
resource "aws_iam_user_policy_attachment" "regular-policy-attach" {
  for_each   = data.aws_iam_policy.policy
  user       = aws_iam_user.user.name
  policy_arn = each.value.arn
}

# custom policy 붙이기
resource "aws_iam_user_policy_attachment" "custom-policy-attach" {
  for_each   = {for policy in var.policy : policy.policy_name => policy if policy.custom_policy == true}
  user       = aws_iam_user.user.name
  policy_arn = each.value.policy
}