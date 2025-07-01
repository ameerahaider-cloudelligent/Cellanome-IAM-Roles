resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-AppSync"
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
  name = "cloud-appsync-ci-cd-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Action" : "iam:PassRole",
        "Resource" : "arn:aws:iam::${var.account_id}:role/GitHubAction-AssumeRoleWithAction-Experiments",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "cloudformation:CreateChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStacks",
          "cloudformation:GetTemplate",
          "cloudformation:GetTemplateSummary",
          "cloudformation:DescribeStackResource"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "s3:DeleteObject",
          "s3:GetObject*",
          "s3:PutObject*",
          "s3:GetBucket*",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/cloud-appsync/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts"
        ],
        "Effect" : "Allow"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:DeleteRole",
          "iam:CreateRole",
          "iam:GetRolePolicy",
          "iam:PutRolePolicy",
          "iam:PassRole",
          "iam:DeleteRolePolicy"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:role/*cloud-appsync*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "appsync:*"
        ],
        "Resource" : [
          "arn:aws:appsync:us-west-1:${var.account_id}:*",
          "arn:aws:appsync:us-west-1:${var.account_id}:*/*"
        ]
      }
    ]
  })
}
