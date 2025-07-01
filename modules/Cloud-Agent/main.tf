resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubAction-AssumeRoleWithAction-Cloud-Agent"
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
            "token.actions.githubusercontent.com:sub" = "repo:cellanome/cloud-agent-*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_greengrass" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGreengrassFullAccess" # AWS managed policy
}

resource "aws_iam_role_policy_attachment" "attach_iot" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSIoTFullAccess" # AWS managed policy
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "cloud-agent-component-artifacts-s3"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::cellanome-${var.env}-cloud-agent-components",
          "arn:aws:s3:::cellanome-${var.env}-cloud-agent-components/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_policy1" {
  name = "cloud-agent-components-cdk"
  role = aws_iam_role.github_oidc_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeChangeSet",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStacks",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:GetTemplate",
          "cloudformation:DeleteChangeSet"
        ],
        "Resource" : [
          "arn:aws:cloudformation:us-west-2:${var.account_id}:stack/CDKToolkit/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DescribeRepositories",
          "ecr:SetRepositoryPolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:PutImageTagMutability",
          "ecr:PutLifecyclePolicy"
        ],
        "Resource" : [
          "arn:aws:ecr:us-west-2:${var.account_id}:repository/cdk-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:DeleteRole",
          "iam:TagRole",
          "iam:PutRolePolicy",
          "iam:UpdateAssumeRolePolicy"
        ],
        "Resource" : [
          "arn:aws:iam::${var.account_id}:role/cdk-*",
          "arn:aws:iam::${var.account_id}:policy/*"
        ]
      },
      {
        "Action" : [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketVersioning",
          "s3:PutEncryptionConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:GetBucketLocation",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::cdk-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:DeleteParameter",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:PutParameter"
        ],
        "Resource" : [
          "arn:aws:ssm:us-west-2:${var.account_id}:parameter/cdk-*"
        ]
      },
      {
        "Sid" : "assumerolecdk",
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole",
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/cdk-readOnlyRole",
          "arn:aws:iam::*:role/cdk-hnb659fds-deploy-role-*",
          "arn:aws:iam::*:role/cdk-hnb659fds-file-publishing-*",
          "arn:aws:iam::*:role/cdk-hnb659fds-lookup-role-*"
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
