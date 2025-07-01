resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Networking"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-networking:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "vpc-management"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateVpc",
          "ec2:CreateSubnet",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateRouteTable",
          "ec2:CreateRoute",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:AssociateRouteTable",
          "ec2:ModifyVpcAttribute",
          "ec2:Describe*",
          "ec2:CreateNatGateway",
          "ec2:ReplaceRoute",
          "ec2:DeleteRoute"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:DeleteInternetGateway",
        "Resource" : "arn:aws:ec2:*:*:internet-gateway/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/Name" : [
              "dev-main-igw",
              "qa-main-igw",
              "int-main-igw"
            ]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:DeleteRoute"
        ],
        "Resource" : "arn:aws:ec2:*:*:route-table/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/Name" : [
              "dev-main-public-route-table",
              "qa-main-public-route-table",
              "int-main-public-route-table"
            ]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DeleteSecurityGroup",
          "ec2:ModifySecurityGroupRules",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
        ],
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/Name" : [
              "dev-main-default-sg",
              "qa-main-default-sg",
              "int-main-default-sg"
            ]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:CreateSecurityGroup",
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/Name" : [
              "dev-main-default-sg",
              "qa-main-default-sg",
              "int-main-default-sg"
            ]
          },
          "ForAllValues:StringEquals" : {
            "aws:TagKeys" : "Stack"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:CreateTags",
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:CreateAction" : "CreateSecurityGroup"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeVpcs",
          "ec2:DescribeSecurityGroups"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:CreateSecurityGroup",
        "Resource" : "arn:aws:ec2:*:*:vpc/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:ModifySecurityGroupRules"
        ],
        "Resource" : "arn:aws:ec2:us-west-1:${var.account_id}:security-group/*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:us-west-1:${var.account_id}:vpc/vpc-id"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeTags"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AllocateAddress"
        ],
        "Resource" : "arn:aws:ec2:us-west-1:${var.account_id}:elastic-ip/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags"
        ],
        "Resource" : [
          "arn:aws:ec2:us-west-1:${var.account_id}:*"
        ]
      },
      {
        "Sid" : "VisualEditor6",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-state-tf/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*"
        ]
      },
      {
        "Sid" : "VisualEditor4",
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
          "arn:aws:s3:::cellanome-state-tf",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:ModifySubnet*",
          "ec2:DisassociateRouteTable",
          "ec2:DeleteSubnet",
          "ec2:DeleteTags"
        ],
        "Resource" : [
          "arn:aws:ec2:us-west-1:${var.account_id}:subnet/subnet-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DisassociateRouteTable",
          "ec2:DeleteRouteTable"
        ],
        "Resource" : [
          "arn:aws:ec2:us-west-1:${var.account_id}:route-table/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DeleteVpc"
        ],
        "Resource" : [
          "arn:aws:ec2:us-west-1:${var.account_id}:vpc/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DeleteNatGateway"
        ],
        "Resource" : [
          "arn:aws:ec2:us-west-1:${var.account_id}:natgateway/nat-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AcceptVpcPeeringConnection"
        ],
        "Resource" : [
          "arn:aws:ec2:us-west-1:${var.account_id}:vpc-peering-connection/*",
          "arn:aws:ec2:us-west-1:${var.account_id}:vpc/*"
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
      }
    ]
  })
}
