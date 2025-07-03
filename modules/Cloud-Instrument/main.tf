resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Instrument"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-instrument-service:*"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "pods.eks.amazonaws.com"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_ec2" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # AWS managed policy
}

resource "aws_iam_role_policy" "inline_policy" {
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

resource "aws_iam_role_policy" "inline_policy1" {
  name = "cloud-ssm-param-deployment"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:*",
          "cloudfront:*",
          "dynamodb:*",
          "events:DescribeEventBus",
          "events:UpdateArchive",
          "events:*",
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "lambda:*",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:CreateLogGroup",
          "logs:ListTagsForResource",
          "scheduler:*",
          "sns:*",
          "sqs:deletequeue",
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor2",
        "Effect" : "Allow",
        "Action" : "dynamodb:UpdateTimeToLive",
        "Resource" : [
          "arn:aws:dynamodb:us-west-1:${var.account_id}:table/*-cloud-instrument-service-event-store-table",
          //"arn:aws:dynamodb:us-west-1:${var.account_id}:table/qa-cloud-instrument-service-event-store-table",
          //"arn:aws:dynamodb:us-west-1:${var.account_id}:table/int-cloud-instrument-service-event-store-table",
          "arn:aws:dynamodb:us-west-1:${var.account_id}:table/*-cloud-instrument-service-telemetry-table",
          //"arn:aws:dynamodb:us-west-1:${var.account_id}:table/dev-cloud-instrument-service-telemetry-table",
          //"arn:aws:dynamodb:us-west-1:${var.account_id}:table/qa-cloud-instrument-service-telemetry-table",
          //"arn:aws:dynamodb:us-west-1:${var.account_id}:table/int-cloud-instrument-service-telemetry-table"
        ]
      },
      {
        "Sid" : "VisualEditor3",
        "Effect" : "Allow",
        "Action" : [
          "eks:UntagResource",
          "eks:DeleteAddon",
          "eks:TagResource",
          "eks:UpdateAddon",
          "eks:CreateAddon",
          "eks:ListAddons",
          "eks:DescribeAddon"
        ],
        "Resource" : [
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/dev-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/qa-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/int-cellanome-cloud-eks"
          "arn:aws:eks:us-west-1:${var.account_id}:cluster/*cellanome-cloud-eks"
        ]
      },
      {
        "Sid" : "VisualEditor5",
        "Effect" : "Allow",
        "Action" : [
          "events:CreateArchive",
          "events:DescribeArchive",
          "events:DeleteArchive"
        ],
        "Resource" : [
          "arn:aws:events:us-west-1:${var.account_id}:event-bus/*-main",
          //"arn:aws:events:us-west-1:${var.account_id}:event-bus/dev-main",
          //"arn:aws:events:us-west-1:${var.account_id}:event-bus/qa-main",
          //"arn:aws:events:us-west-1:${var.account_id}:event-bus/int-main",
          "arn:aws:events:us-west-1:${var.account_id}:archive/*-cloud-instrument-service-register-scan",
          //"arn:aws:events:us-west-1:${var.account_id}:archive/dev-cloud-instrument-service-register-scan",
          //"arn:aws:events:us-west-1:${var.account_id}:archive/qa-cloud-instrument-service-register-scan",
          //"arn:aws:events:us-west-1:${var.account_id}:archive/int-cloud-instrument-service-register-scan"
        ]
      },
      {
        "Sid" : "VisualEditor6",
        "Effect" : "Allow",
        "Action" : "events:DescribeEventBus",
        "Resource" : [
          "arn:aws:events:us-west-1:${var.account_id}:event-bus/*-main",
          //"arn:aws:events:us-west-1:${var.account_id}:event-bus/dev-main",
          //"arn:aws:events:us-west-1:${var.account_id}:event-bus/qa-main",
          //"arn:aws:events:us-west-1:${var.account_id}:event-bus/int-main"
        ]
      },
      {
        "Sid" : "VisualEditor9",
        "Effect" : "Allow",
        "Action" : "lambda:ListTags",
        "Resource" : "arn:aws:lambda:us-west-1:${var.account_id}:event-source-mapping:*"
      },
      {
        "Sid" : "VisualEditor11",
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : [
          "arn:aws:eks:us-west-1:${var.account_id}:cluster/*-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/dev-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/qa-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/int-cellanome-cloud-eks"
        ]
      },
      {
        "Sid" : "VisualEditor12",
        "Effect" : "Allow",
        "Action" : "logs:ListTagsForResource",
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*-cloud-instrument-service-*",
          //"arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/dev-cloud-instrument-service-*",
          //"arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/qa-cloud-instrument-service-*",
          //"arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/int-cloud-instrument-service-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group::log-stream:*"
        ]
      },
      {
        "Sid" : "VisualEditor16",
        "Effect" : "Allow",
        "Action" : "sqs:deletequeue",
        "Resource" : [
          "arn:aws:sqs:us-west-1:${var.account_id}:*-cloud-instrument-service-iot-message-queue",

          //"arn:aws:sqs:us-west-1:${var.account_id}:dev-cloud-instrument-service-iot-message-queue",
          //"arn:aws:sqs:us-west-1:${var.account_id}:qa-cloud-instrument-service-iot-message-queue",
          //"arn:aws:sqs:us-west-1:${var.account_id}:int-cloud-instrument-service-iot-message-queue"
        ]
      },
      {
        "Sid" : "VisualEditor17",
        "Effect" : "Allow",
        "Action" : "eks:Describe*",
        "Resource" : [
          "arn:aws:eks:us-west-1:${var.account_id}:cluster/*-cellanome-cloud-eks",

          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/dev-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/qa-cellanome-cloud-eks",
          //"arn:aws:eks:us-west-1:${var.account_id}:cluster/int-cellanome-cloud-eks"
        ]
      },
      {
        "Sid" : "VisualEditor18",
        "Effect" : "Allow",
        "Action" : [
          "iam:Get*",
          "iam:List*"
        ],
        "Resource" : "arn:aws:iam::${var.account_id}:oidc-provider/*"
      },
      {
        "Sid" : "VisualEditor19",
        "Effect" : "Allow",
        "Action" : "glue:*",
        "Resource" : [
          "arn:aws:glue:us-west-1:${var.account_id}:registry/*-main",
          //"arn:aws:glue:us-west-1:${var.account_id}:registry/dev-main",
          //"arn:aws:glue:us-west-1:${var.account_id}:registry/qa-main",
          //"arn:aws:glue:us-west-1:${var.account_id}:registry/int-main",
          "arn:aws:glue:us-west-1:${var.account_id}:schema/*-main/*",
          //"arn:aws:glue:us-west-1:${var.account_id}:schema/dev-main/*",
          //"arn:aws:glue:us-west-1:${var.account_id}:schema/qa-main/*",
          //"arn:aws:glue:us-west-1:${var.account_id}:schema/int-main/*"
        ]
      },
      {
        "Sid" : "VisualEditor20",
        "Effect" : "Allow",
        "Action" : "logs:DescribeLogGroups",
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/dev-cloud-instrument-service-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/qa-cloud-instrument-service-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/int-cloud-instrument-service-*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group::log-stream:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_policy2" {
  name = "instrument-service-tf-execution"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "iam:*",
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
          "logs:CreateLogGroup"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "lambda:UpdateFunctionCode",
          "iam:CreateServiceLinkedRole"
        ],
        "Resource" : [
          "arn:aws:lambda:us-west-1:${var.account_id}:function:*-instrument-service*",
          "arn:aws:iam::*:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"
        ]
      },
      {
        "Sid" : "VisualEditor2",
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
          "arn:aws:iam::${var.account_id}:policy/*instrument-service*",
          "arn:aws:iam::${var.account_id}:policy/*integration-cognito-id-token*",
          "arn:aws:iam::aws:policy/service-role/*",
          "arn:aws:iam::${var.account_id}:role/*instrument*service*",
          "arn:aws:iam::${var.account_id}:role/*integration-cognito-id-token*",
          "arn:aws:iam::${var.account_id}:role/*_instrument_service_download_dataset_appsync-role"
        ]
      },
      {
        "Sid" : "VisualEditor3",
        "Effect" : "Allow",
        "Action" : [
          "logs:ListTagsLogGroup",
          "logs:DeleteLogGroup",
          "lambda:GetLayerVersion",
          "lambda:PublishLayerVersion",
          "s3:List*",
          "s3:Get*",
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
          "logs:PutRetentionPolicy"
        ],
        "Resource" : [
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*-instrument-service*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/events/*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*integration-cognito-id-token*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/api-gateway/int-integration-service-rest-api*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:iam::*:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway",
          "arn:aws:lambda:*:${var.account_id}:layer:*:*",
          "arn:aws:lambda:us-west-1:${var.account_id}:layer:sharp-lib-x64"
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
          "arn:aws:events:us-west-1:${var.account_id}:rule/*-event-bus/*-instrument-service-instrument-event",
          "arn:aws:lambda:us-west-1:${var.account_id}:event-source-mapping:*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:*-instrument-service*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:int-integration-cognito-id-token*",
          "arn:aws:dynamodb:*:*:table/tf-state-locking",
          "arn:aws:dynamodb:*:*:table/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:*",
          "arn:aws:sqs:us-west-1:${var.account_id}:*-instrument-service*"
        ]
      },
      {
        "Sid" : "VisualEditor6",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/instrument-service/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/instrument-service/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/instrument-service",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/instrument-service",
          "arn:aws:s3:::cellanome-${var.env}-nextflow-output",
          "arn:aws:s3:::cellanome-${var.env}-instrument"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:CreateRepository",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:DeleteRepository",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:CreateTable"
        ],
        "Resource" : [
          "arn:aws:dynamodb:us-west-1:${var.account_id}:table/dev-cloud-instrument-service-*",
          "arn:aws:dynamodb:us-west-1:${var.account_id}:table/qa-cloud-instrument-service-*",
          "arn:aws:dynamodb:us-west-1:${var.account_id}:table/int-cloud-instrument-service-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "logs:ListTagsForResource",
        "Resource" : "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*-cloud-instrument-service-*"
      }
    ]
  })
}
