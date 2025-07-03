resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Terraform-Commons"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-terraform-commons:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "s3-terraform-state-bucket"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/cloud-terraform-commons",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/cloud-terraform-commons/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:GetPolicy",
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:CreatePolicy",
          "iam:PutRolePolicy",
          "iam:TagPolicy",
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:GetPolicyVersion",
          "iam:ListAttachedRolePolicies",
          "iam:ListPolicyVersions",
          "iam:CreatePolicyVersion",
          "iam:TagRole"
        ],
        "Resource" : "*"
      }
    ]
  })
}
