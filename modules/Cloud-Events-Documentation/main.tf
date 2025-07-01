resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Events-Documentation"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-events-documentation:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "cellanome-events-documentation-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:GetCallerIdentity",
          "cloudfront:CreateInvalidation",
          "ssm:GetParametersByPath",
          "logs:*",
          "iam:*",
          "cloudfront:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::cellanome-${var.env}-terraform-state"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectTagging",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:s3:::cellanome-${var.env}-events-documentation/*",
          "arn:aws:s3:::cellanome-${var.env}-events-documentation"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/cellanome-events-documentation/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/cellanome-events-documentation/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/cellanome-events-documentation",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/cellanome-events-documentation"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTagsOfResource",
          "dynamodb:UpdateTable"
        ],
        "Resource" : [
          "arn:aws:dynamodb:*:*:table/tf-state-locking"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:CreateRole",
          "iam:TagRole",
          "iam:ListInstanceProfilesForRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:GetRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:role/*cellanome-events-documentation*",
          "arn:aws:iam::${var.account_id}:policy/*cellanome-events-documentation*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cognito-idp:ListUserPools",
          "cognito-idp:CreateUserPool",
          "cognito-idp:SetUserPoolMfaConfig",
          "cognito-idp:DescribeUserPool",
          "cognito-idp:GetUserPoolMfaConfig",
          "cognito-idp:DeleteUserPool",
          "cognito-idp:CreateUserPoolClient",
          "cognito-idp:CreateUserPoolDomain",
          "cognito-identity:CreateIdentityPool",
          "cognito-idp:DescribeUserPoolDomain",
          "cognito-idp:DescribeUserPoolClient",
          "cognito-idp:DeleteUserPoolDomain",
          "cognito-identity:DescribeIdentityPool",
          "cognito-identity:DeleteIdentityPool",
          "cognito-identity:SetIdentityPoolRoles",
          "cognito-identity:GetIdentityPoolRoles",
          "cognito-idp:UpdateUserPool",
          "cognito-idp:TagResource",
          "cognito-identity:TagResource",
          "cognito-idp:UpdateUserPoolClient",
          "cognito-idp:DeleteUserPoolClient"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:*",
          "s3:*"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_policy1" {
  name = "cloud-release-artifacts-rw"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:*",
          "s3:PutObject"
        ],
        "Resource" : [
          "*",
          "arn:aws:s3:::cellanome-${var.env}-cloud-release-artifacts",
          "arn:aws:s3:::cellanome-${var.env}-cloud-release-artifacts/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:CreateInvalidation"
        ],
        "Resource" : "arn:aws:cloudfront::${var.account_id}:distribution/E2XHNE9D0YOBID"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:CreateTable",
          "dynamodb:TagResource"
        ],
        "Resource" : [
          "arn:aws:dynamodb:us-west-1:*:table/*-restoration-jobs-table"
        ]
      }
    ]
  })
}
