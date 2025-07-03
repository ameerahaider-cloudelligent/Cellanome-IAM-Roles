resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-CloudSpotterDataIngestion"
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
  name = "cloud-spotter-data-ingestion-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "iam:UpdateAssumeRolePolicy",
          "logs:DescribeLogGroups",
          "lambda:GetEventSourceMapping",
          "lambda:GetLayerVersion",
          "lambda:PublishLayerVersion",
          "lambda:AddLayerVersionPermission",
          "lambda:CreateEventSourceMapping",
          "lambda:GetLayerVersionPolicy",
          "lambda:RemoveLayerVersionPermission",
          "lambda:DeleteLayerVersion",
          "lambda:ListEventSourceMappings",
          "lambda:ListLayerVersions",
          "lambda:ListLayers",
          "lambda:DeleteEventSourceMapping",
          "logs:DescribeResourcePolicies"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "logs:ListTagsLogGroup",
          "iam:GetPolicyVersion",
          "iam:DeletePolicy",
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:DeleteRolePolicy",
          "iam:CreatePolicyVersion",
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:GetPolicy",
          "logs:DeleteLogGroup",
          "iam:DeleteRole",
          "logs:TagResource",
          "logs:CreateLogGroup",
          "iam:CreatePolicy",
          "lambda:UpdateFunctionCode",
          "iam:ListPolicyVersions",
          "logs:PutRetentionPolicy",
          "iam:GetRolePolicy",
          "iam:DeletePolicyVersion"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:role/*spotter*",
          "arn:aws:iam::${var.account_id}:role/*spotterFSRB*",
          "arn:aws:iam::${var.account_id}:policy/*spotter*",
          "arn:aws:iam::${var.account_id}:policy/*spotterFSRB*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:spotter-logs-ingestion",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:spotterFSRB-log-ingestion",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:spotterFSRB_logs:*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:spotter_logs:*"
        ]
      },
      {
        "Sid" : "VisualEditor2",
        "Effect" : "Allow",
        "Action" : [
          "logs:ListTagsLogGroup",
          "lambda:CreateFunction",
          "iam:GetPolicyVersion",
          "iam:GetPolicy",
          "lambda:ListVersionsByFunction",
          "lambda:GetFunction",
          "logs:DescribeSubscriptionFilters",
          "lambda:UpdateFunctionConfiguration",
          "lambda:DeleteFunction",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:GetPolicy"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:spotterFSRB_logs:*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:spotter_logs:*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:spotter-logs-ingestion",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:spotterFSRB-log-ingestion",
          "arn:aws:iam::${var.account_id}:policy/AWSXRayDaemonWriteAccess"
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
