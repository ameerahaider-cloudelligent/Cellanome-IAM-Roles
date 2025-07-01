resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Kubernetes"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-kubernetes-cluster:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy0" {
  name = "cloud-ssm-param-deployment"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource" : [
          "arn:aws:ssm:us-west-1:${var.account_id}:parameter/cellanome/cloud/dev/*",
          "arn:aws:ssm:us-west-1:${var.account_id}:parameter/cellanome/cloud/qa/*",
          "arn:aws:ssm:us-west-1:${var.account_id}:parameter/cellanome/cloud/int/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "ssm:DescribeParameters",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "inline-policy"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "VisualEditor6",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "eks:*",
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:Describe*"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : [
          "*"
        ],
        "Condition" : {
          "StringEquals" : {
            "iam:PassedToService" : "eks.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreatePolicy",
          "iam:CreateRole",
          "elasticfilesystem:CreateMountTarget",
          "iam:CreateOpenIDConnectProvider",
          "iam:GetRole",
          "iam:GetOpenIDConnectProvider"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:CreateFunction",
          "logs:ListTagsLogGroup",
          "iam:GetPolicyVersion",
          "lambda:TagResource",
          "logs:DeleteSubscriptionFilter",
          "lambda:ListVersionsByFunction",
          "dynamodb:DeleteItem",
          "sqs:UntagQueue",
          "logs:DescribeSubscriptionFilters",
          "sqs:ReceiveMessage",
          "dynamodb:ListTagsOfResource",
          "s3:ListBucket",
          "sqs:ListQueueTags",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:DescribeContinuousBackups",
          "lambda:DeleteFunction",
          "events:ListTargetsByRule",
          "sqs:SetQueueAttributes",
          "events:DescribeRule",
          "sqs:GetQueueUrl",
          "sqs:ListMessageMoveTasks",
          "dynamodb:PutItem",
          "iam:GetPolicy",
          "lambda:GetEventSourceMapping",
          "lambda:GetFunction",
          "lambda:UpdateFunctionConfiguration",
          "sqs:GetQueueAttributes",
          "dynamodb:DescribeTimeToLive",
          "lambda:GetFunctionCodeSigningConfig",
          "sqs:TagQueue",
          "lambda:AddPermission",
          "sqs:ListDeadLetterSourceQueues",
          "events:ListTagsForResource",
          "logs:PutSubscriptionFilter",
          "sqs:CreateQueue",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "dynamodb:UpdateTable",
          "dynamodb:DeleteTable"
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
          "iam:GetRole",
          "iam:GetPolicyVersion",
          "iam:GetPolicy",
          "iam:TagRole",
          "iam:DeletePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:CreatePolicy",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole",
          "iam:DetachRolePolicy",
          "iam:ListPolicyVersions",
          "iam:ListAttachedRolePolicies",
          "iam:DeleteRolePolicy",
          "iam:CreatePolicyVersion",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:DeletePolicyVersion"
        ],
        "Resource" : [
          "arn:aws:iam::*:policy/dev-cellanome-cloud-*-policy",
          "arn:aws:iam::*:role/dev-cellanome-cloud-*-role*",
          "arn:aws:iam::*:policy/qa-cellanome-cloud-*-policy",
          "arn:aws:iam::*:role/qa-cellanome-cloud-*-role*",
          "arn:aws:iam::*:policy/int-cellanome-cloud-*-policy",
          "arn:aws:iam::*:role/int-cellanome-cloud-*-role*",
          "arn:aws:iam::aws:policy/service-role/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticfilesystem:TagResource",
          "elasticfilesystem:CreateFileSystem",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeLifecycleConfiguration",
          "elasticfilesystem:DeleteFileSystem",
          "elasticfilesystem:PutLifecycleConfiguration",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeMountTargetSecurityGroups",
          "elasticfilesystem:DeleteMountTarget"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:GetRole",
          "iam:GetInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:ListInstanceProfiles",
          "iam:AddRoleToInstanceProfile",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole",
          "iam:CreateServiceLinkedRole",
          "iam:DetachRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:DeleteServiceLinkedRole",
          "iam:GetRolePolicy"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/eksctl-*",
          "arn:aws:iam::*:instance-profile/eksctl-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:DeleteOpenIDConnectProvider",
        "Resource" : [
          "arn:aws:iam::*:oidc-provider/oidc.eks.us-west-1.amazonaws.com/id/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy",
          "logs:DeleteLogGroup"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/eks/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:Describe*",
          "logs:List*"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}
