resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Cost-Estimate"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-cost-estimate:*"
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
  name = "cloud-cost-estimate-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:PutObjectTagging",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/cloud-cost-estimate/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/cloud-cost-estimate/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:DeleteItem"
        ],
        "Resource" : [
          "arn:aws:dynamodb:us-west-1:${var.account_id}:table/tf-state-locking"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:TagPolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:policy/dev-cloud-cost-estimate-*",
          "arn:aws:iam::${var.account_id}:policy/qa-cloud-cost-estimate-*",
          "arn:aws:iam::${var.account_id}:policy/int-cloud-cost-estimate-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:DetachRolePolicy",
          "iam:PassRole",
          "iam:UpdateAssumeRolePolicy"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:role/dev-cloud-cost-estimate-*",
          "arn:aws:iam::${var.account_id}:role/qa-cloud-cost-estimate-*",
          "arn:aws:iam::${var.account_id}:role/int-cloud-cost-estimate-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:TagResource",
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/dev-cloud-cost-estimate-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/qa-cloud-cost-estimate-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/int-cloud-cost-estimate-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogGroups"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group::log-stream:"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "events:PutRule",
          "events:TagResource",
          "events:DescribeRule",
          "events:ListTagsForResource",
          "events:PutTargets",
          "events:ListTargetsByRule",
          "events:RemoveTargets",
          "events:DeleteRule"
        ],
        "Resource" : [
          "arn:aws:events:us-west-1:${var.account_id}:rule/dev-event-bus/dev-cloud-cost-estimate-relevant-events",
          "arn:aws:events:us-west-1:${var.account_id}:rule/qa-event-bus/qa-cloud-cost-estimate-relevant-events",
          "arn:aws:events:us-west-1:${var.account_id}:rule/int-event-bus/int-cloud-cost-estimate-relevant-events",
          "arn:aws:events:us-west-1:${var.account_id}:rule/dev-cloud-cost-estimate-relevant-aws-events",
          "arn:aws:events:us-west-1:${var.account_id}:rule/qa-cloud-cost-estimate-relevant-aws-events",
          "arn:aws:events:us-west-1:${var.account_id}:rule/int-cloud-cost-estimate-relevant-aws-events"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "scheduler:CreateSchedule",
          "scheduler:TagResource",
          "scheduler:UntagResource",
          "scheduler:DeleteSchedule",
          "scheduler:UpdateSchedule",
          "scheduler:GetSchedule",
          "scheduler:ListTagsForResource",
          "scheduler:ListSchedules"
        ],
        "Resource" : [
          "arn:aws:scheduler:us-west-1:${var.account_id}:schedule/default/dev-cloud-cost-estimate-daily-trigger",
          "arn:aws:scheduler:us-west-1:${var.account_id}:schedule/default/qa-cloud-cost-estimate-daily-trigger",
          "arn:aws:scheduler:us-west-1:${var.account_id}:schedule/default/int-cloud-cost-estimate-daily-trigger"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:CreateRepository",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:DeleteRepository",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        "Resource" : [
          "arn:aws:ecr:us-west-1:${var.account_id}:repository/dev-cloud-cost-estimate-s3-measure",
          "arn:aws:ecr:us-west-1:${var.account_id}:repository/qa-cloud-cost-estimate-s3-measure",
          "arn:aws:ecr:us-west-1:${var.account_id}:repository/int-cloud-cost-estimate-s3-measure"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcAttribute"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:*"
        ],
        "Resource" : [
          "arn:aws:lambda:us-west-1:${var.account_id}:function:dev-cloud-cost-estimate-*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:qa-cloud-cost-estimate-*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:int-cloud-cost-estimate-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:*"
        ],
        "Resource" : [
          "arn:aws:lambda:us-west-1:464622532012:layer:Datadog-Node*-x:*",
          "arn:aws:lambda:us-west-1:464622532012:layer:Datadog-Extension:*"
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
          "appsync:GraphQL"
        ],
        "Resource" : "*"
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
