# #!/bin/bash
# set -e

# AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
# GITHUB_REPO="ashishhake/portfolio-site"
# AWS_REGION="ap-south-1"
# ROLE_NAME="github-actions-deploy-role"
# POLICY_NAME="github-actions-deploy-policy"

# echo "Creating GitHub OIDC provider (if not exists)..."

# aws iam create-open-id-connect-provider \
#   --url https://token.actions.githubusercontent.com \
#   --client-id-list sts.amazonaws.com \
#   2>/dev/null || echo "OIDC provider already exists"

# echo "Updating trust policy with account and repo..."

# sed "s/ACCOUNT_ID/$AWS_ACCOUNT_ID/g; s|GITHUB_REPO|$GITHUB_REPO|g" \
#   iam-trust-policy.json > trust-policy.json

# echo "Creating IAM role..."

# aws iam create-role \
#   --role-name $ROLE_NAME \
#   --assume-role-policy-document file://iam-trust-policy.json \
#   2>/dev/null || echo "Role already exists"

# echo "Creating IAM policy..."

# aws iam create-policy \
#   --policy-name $POLICY_NAME \
#   --policy-document file://iam-deploy-policy.json \
#   2>/dev/null || echo "Policy may already exist"

# echo "Attaching policy to role..."

# aws iam attach-role-policy \
#   --role-name $ROLE_NAME \
#   --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/$POLICY_NAME

# echo ""
# echo "======================================"
# echo "Add this to GitHub Secrets:"
# echo ""
# echo "AWS_ROLE_ARN=arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME"
# echo "======================================"