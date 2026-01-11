locals {
  policy_list = {
    "sts" = {
      policy = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": "sts:*",
                "Resource": "*"
            }
        ]
      }
    }

    "s3-access" = {
      policy = {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:ListBucket",
              "s3:PutObject"
            ],
            "Resource": [
              "arn:aws:s3:::*",
              "arn:aws:s3:::*/*"
            ]
          }
        ]
      }
    }
  }
}

module "policy" {
  source      = "./module/IAM_Policy"
  for_each    = local.policy_list
  name        = each.key
  path        = try(each.value.path,null)
  description = try(each.value.description,null)
  policy      = each.value.policy
}