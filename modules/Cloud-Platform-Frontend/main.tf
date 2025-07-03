resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Platform-Frontend"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "cloud-platform-frontend-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:*",
          "cloudformation:*",
          "amplify:*",
          "cognito-idp:ListUserPools",
          "cognito-idp:DescribeUserPoolClient",
          "cognito-idp:UpdateUserPoolClient"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor7",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state"
        ]
      },
      {
        "Sid" : "VisualEditor8",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-cloud-platform-ui",
          "arn:aws:s3:::cellanome-${var.env}-cloud-platform-ui/*",
        ]
      },
      {
        "Sid" : "VisualEditor9",
        "Effect" : "Allow",
        "Action" : "dynamodb:*",
        "Resource" : [
          "arn:aws:dynamodb:*:*:table/tf-state-locking"
        ]
      }
    ]
  })
}
