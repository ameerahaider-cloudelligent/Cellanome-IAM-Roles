resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-CDN"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-cdn:*"
          }
        }
      },
      /*{
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_id}:user/pedro.godoy"
        },
        "Action" : "sts:AssumeRole"
      }*/
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "cloud-cdn-service-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "s3:PutObject",
          "s3:GetObject",
          "s3:PutObjectTagging",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:GetObjectTagging"
        ],
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:GetPolicyVersion",
          "dynamodb:DeleteItem",
          "dynamodb:ListTagsOfResource",
          "s3:ListBucket",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:PutItem",
          "iam:GetPolicy",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:UpdateTable"
        ],
        "Resource" : [
          "arn:aws:dynamodb:*:*:table/tf-state-locking",
          "arn:aws:dynamodb:*:*:table/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParametersByPath"
        ],
        "Resource" : [
          "arn:aws:ssm:*:*:parameter/cellanome/cloud/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:*Get*",
          "cloudfront:*List*",
          "cloudfront:CreateOriginAccessControl",
          "cloudfront:UpdateResponseHeadersPolicy"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:UpdateDistribution"
        ],
        "Resource" : [
          "arn:aws:cloudfront::${var.account_id}:distribution/E1232EFYRY18A1",
          "arn:aws:cloudfront::${var.account_id}:distribution/E23AEA4BI1GNI7",
          "arn:aws:cloudfront::${var.account_id}:distribution/E3UGAU0P0GTIOR"
        ]
      }
    ]
  })
}
