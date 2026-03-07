#!/bin/bash
set -e

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
GITHUB_ORG="your-github-username"
GITHUB_REPO="your-repo-name"
ROLE_NAME="github-actions-deploy-role"
S3_BUCKET_NAME="your-bucket-name"

echo "Creating OIDC provider..."
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

echo "Creating IAM role..."
aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::'"$AWS_ACCOUNT_ID"':oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:sub": "repo:'"$GITHUB_ORG"'/'"$GITHUB_REPO"':ref:refs/heads/main"
        }
      }
    }]
  }'

echo "Attaching policy..."
aws iam put-role-policy \
  --role-name $ROLE_NAME \
  --policy-name "deploy-policy" \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:PutObject", "s3:DeleteObject", "s3:ListBucket"],
        "Resource": [
          "arn:aws:s3:::'"$S3_BUCKET_NAME"'",
          "arn:aws:s3:::'"$S3_BUCKET_NAME"'/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": "cloudfront:CreateInvalidation",
        "Resource": "*"
      }
    ]
  }'

echo "Done! Role ARN: arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME"