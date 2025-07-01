resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Annotations"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-annotations:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "cloud-annotations-service-tf-execution"
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
          "logs:PutRetentionPolicy",
          "logs:ListTagsForResource",
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
          "arn:aws:lambda:us-west-1:${var.account_id}:function:*-cloud-annotations*",
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
          "arn:aws:iam::${var.account_id}:policy/*cloud-annotations*",
          "arn:aws:iam::${var.account_id}:policy/*integration-cognito-id-token*",
          "arn:aws:iam::aws:policy/service-role/*",
          "arn:aws:iam::${var.account_id}:role/*cloud-annotations*",
          "arn:aws:iam::${var.account_id}:role/*cloud_annotations*",
          "arn:aws:iam::${var.account_id}:role/*integration-cognito-id-token*",
          "arn:aws:iam::*:role/AWSBatchJobRole*"
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
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*-cloud-annotations*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/events/*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/lambda/*integration-cognito-id-token*",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:/aws/api-gateway/int-integration-service-rest-api*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state/*",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:iam::*:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"
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
          "arn:aws:lambda:us-west-1:${var.account_id}:function:*-cloud-annotations*",
          "arn:aws:lambda:us-west-1:${var.account_id}:function:int-integration-cognito-id-token*",
          "arn:aws:dynamodb:*:*:table/tf-state-locking",
          "arn:aws:dynamodb:*:*:table/*",
          "arn:aws:s3:::cellanome-${var.env}-terraform-state",
          "arn:aws:s3:::cellanome-${var.env}-build-artifacts",
          "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess",
          "arn:aws:logs:us-west-1:${var.account_id}:log-group:*",
          "arn:aws:sqs:us-west-1:${var.account_id}:*-cloud-annotations*"
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
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy",
          "logs:DeleteLogGroup",
          "logs:TagLogGroup",
          "logs:DeleteRetentionPolicy"
        ],
        "Resource" : "arn:aws:logs:us-west-1:${var.account_id}:log-group:*-cloud-annotations-*"
      },
      {
        "Effect" : "Allow",
        "Action" : "lambda:GetLayerVersion",
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

resource "aws_iam_role_policy" "inline_policy2" {
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
