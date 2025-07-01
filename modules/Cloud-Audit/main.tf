resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Audit"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-audit:*"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:cellanome/cloud-audit-sdk:*"
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
  name = "cloud-audit-sdk-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:DeleteLogGroup",
          "logs:TagLogGroup",
          "logs:UntagLogGroup"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/kinesisfirehose/dev-cloud-audit-sdk-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/kinesisfirehose/qa-cloud-audit-sdk-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/kinesisfirehose/int-cloud-audit-sdk-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "glue:CreateDatabase",
          "glue:DeleteDatabase",
          "glue:UpdateDatabase",
          "glue:GetDatabases",
          "glue:GetDatabase",
          "glue:GetTags",
          "glue:CreateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:DeleteTableVersion",
          "glue:GetTableVersion",
          "glue:GetTableVersions",
          "glue:SearchTables",
          "glue:BatchDeleteTable",
          "glue:BatchDeleteTableVersion"
        ],
        "Resource" : [
          "arn:aws:glue:us-west-1:${var.account_id}:catalog",
          "arn:aws:glue:us-west-1:${var.account_id}:database/dev-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:table/dev-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:database/qa-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:table/qa-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:database/int-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:table/int-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:userDefinedFunction/dev-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:userDefinedFunction/qa-cloud-audit-sdk-*",
          "arn:aws:glue:us-west-1:${var.account_id}:userDefinedFunction/int-cloud-audit-sdk-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "firehose:CreateDeliveryStream",
          "firehose:ListDeliveryStreams",
          "firehose:DescribeDeliveryStream",
          "firehose:ListTagsForDeliveryStream",
          "firehose:DeleteDeliveryStream",
          "firehose:UpdateDestination",
          "firehose:TagDeliveryStream",
          "firehose:UntagDeliveryStream"
        ],
        "Resource" : [
          "arn:aws:firehose:us-west-1:${var.account_id}:deliverystream/dev-cloud-audit-sdk-*",
          "arn:aws:firehose:us-west-1:${var.account_id}:deliverystream/qa-cloud-audit-sdk-*",
          "arn:aws:firehose:us-west-1:${var.account_id}:deliverystream/int-cloud-audit-sdk-*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_policy1" {
  name = "cloud-audit-service-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:UpdateAssumeRolePolicy",
          "sqs:ListQueues",
          "ec2:DescribeInstances",
          "apigateway:*",
          "lambda:GetEventSourceMapping",
          "ec2:DeleteNetworkInterface",
          "lambda:CreateEventSourceMapping",
          "cognito-idp:ListUserPools",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "lambda:ListEventSourceMappings",
          "ec2:AttachNetworkInterface",
          "lambda:ListLayerVersions",
          "lambda:ListLayers",
          "sts:GetCallerIdentity",
          "ec2:DescribeSubnets",
          "appsync:*",
          "events:PutRule",
          "events:DescribeRule",
          "events:ListTagsForResource",
          "events:DeleteRule",
          "events:PutTargets",
          "events:ListTargetsByRule",
          "events:RemoveTargets",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DeleteResourcePolicy",
          "lambda:DeleteEventSourceMapping",
          "ec2:DescribeVpcAttribute",
          "events:TagResource",
          "logs:ListTagsForResource",
          "logs:PutRetentionPolicy",
          "lambda:ListTags"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:UpdateFunctionCode",
          "iam:CreateServiceLinkedRole"
        ],
        "Resource" : [
          "arn:aws:lambda:us-west-1:${var.account_id}:function:*-cloud-audit*",
          "arn:aws:iam::*:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"
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
          "iam:DeletePolicyVersion",
          "iam:TagPolicy",
          "iam:DeleteRole"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:policy/*cloud-audit*",
          "arn:aws:iam::${var.account_id}:policy/*integration-cognito-id-token*",
          "arn:aws:iam::aws:policy/service-role/*",
          "arn:aws:iam::${var.account_id}:role/*cloud-audit*",
          "arn:aws:iam::${var.account_id}:role/*cloud_audit*",
          "arn:aws:iam::${var.account_id}:role/*integration-cognito-id-token*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:ListTagsLogGroup",
          "logs:DeleteLogGroup",
          "lambda:GetLayerVersion",
          "lambda:PublishLayerVersion",
          "s3:ListBucket",
          "iam:AttachRolePolicy",
          "lambda:AddLayerVersionPermission",
          "iam:PutRolePolicy",
          "logs:TagResource",
          "lambda:GetLayerVersionPolicy",
          "logs:CreateLogGroup",
          "lambda:RemoveLayerVersionPermission",
          "s3:PutObject",
          "s3:GetObject",
          "lambda:DeleteLayerVersion",
          "s3:PutObjectTagging",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "logs:PutRetentionPolicy",
          "s3:GetObjectTagging"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*-cloud-audit*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/events/*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*integration-cognito-id-token*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/api-gateway/int-integration-service-rest-api*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:iam::*:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway",
          "arn:aws:lambda:*:${var.account_id}:layer:*:*",
          "arn:aws:lambda:us-west-1:${var.account_id}:layer:sharp-lib-x64"
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
          "lambda:UntagResource"
        ],
        "Resource" : [
          "arn:aws:lambda:us-west-1:${var.account_id}:event-source-mapping:*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:*-cloud-audit*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:int-integration-cognito-id-token*",
          "arn:aws:dynamodb:*:*:table/tf-state-locking",
          "arn:aws:dynamodb:*:*:table/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:*",
          "arn:aws:sqs:us-west-1:${var.account_id}:*-cloud-audit*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "logs:DescribeLogGroups",
        "Resource" : "arn:aws:logs:us-west-1:${var.account_id}:log-group:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "batch:*",
          "cloudwatch:GetMetricStatistics",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeVpcs",
          "ec2:DescribeImages",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "logs:Describe*",
          "logs:Get*",
          "logs:TestMetricFilter",
          "logs:FilterLogEvents",
          "iam:ListInstanceProfiles",
          "iam:ListRoles"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "events:PutRule",
          "events:DescribeRule",
          "events:DescribeEventBus",
          "events:ListTagsForResource",
          "events:DeleteRule",
          "events:PutTargets",
          "events:ListTargetsByRule",
          "events:RemoveTargets",
          "events:CreateEventBus",
          "events:DeleteEventBus"
        ],
        "Resource" : "arn:aws:events:us-west-1:${var.account_id}:event-bus/*-cloud-audit"
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

resource "aws_iam_role_policy" "inline_policy2" {
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
