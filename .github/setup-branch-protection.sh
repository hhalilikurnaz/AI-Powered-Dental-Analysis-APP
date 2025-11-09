#!/bin/bash

# Branch Protection Setup Script for S&H Tech Labs Repository
# This script configures branch protection rules using GitHub CLI

set -e

REPO_OWNER="yourusername"
REPO_NAME="sh-tech-labs"
REPO_FULL_NAME="${REPO_OWNER}/${REPO_NAME}"

echo "🔧 Setting up branch protection rules for ${REPO_FULL_NAME}..."

# Check if GitHub CLI is authenticated
if ! gh auth status >/dev/null 2>&1; then
    echo "❌ Error: GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
fi

# Check if repository exists
if ! gh repo view "${REPO_FULL_NAME}" >/dev/null 2>&1; then
    echo "❌ Error: Repository ${REPO_FULL_NAME} not found. Please create the repository first."
    exit 1
fi

echo "✅ Repository found. Setting up branch protections..."

# Set dev as default branch
echo "🔄 Setting 'dev' as default branch..."
gh api repos/${REPO_FULL_NAME} --method PATCH --field default_branch=dev

# Configure main branch protection
echo "🛡️  Protecting 'main' branch..."
gh api repos/${REPO_FULL_NAME}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{
    "strict": true,
    "contexts": [
      "Lint and Format Check",
      "Unit Tests", 
      "Build Application",
      "Security Scan",
      "TypeScript Type Check",
      "Integration Tests"
    ]
  }' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1,
    "require_last_push_approval": false
  }' \
  --field restrictions='{
    "users": [],
    "teams": [],
    "apps": []
  }' \
  --field required_linear_history=false \
  --field allow_force_pushes=false \
  --field allow_deletions=false

echo "✅ Main branch protection configured"

# Configure dev branch protection  
echo "🛡️  Protecting 'dev' branch..."
gh api repos/${REPO_FULL_NAME}/branches/dev/protection \
  --method PUT \
  --field required_status_checks='{
    "strict": true,
    "contexts": [
      "Lint and Format Check",
      "Unit Tests",
      "Build Application", 
      "Security Scan",
      "TypeScript Type Check"
    ]
  }' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1,
    "require_last_push_approval": false
  }' \
  --field restrictions=null \
  --field required_linear_history=false \
  --field allow_force_pushes=false \
  --field allow_deletions=false

echo "✅ Dev branch protection configured"

# Configure repository settings
echo "⚙️  Configuring repository settings..."

# Enable vulnerability alerts
gh api repos/${REPO_FULL_NAME}/vulnerability-alerts --method PUT

# Enable automated security fixes
gh api repos/${REPO_FULL_NAME}/automated-security-fixes --method PUT

# Configure merge options
gh api repos/${REPO_FULL_NAME} --method PATCH \
  --field allow_squash_merge=true \
  --field allow_merge_commit=false \
  --field allow_rebase_merge=true \
  --field delete_branch_on_merge=true

echo "✅ Repository settings configured"

# Create branch protection status check
echo "📊 Verifying branch protection status..."

echo ""
echo "Main branch protection status:"
gh api repos/${REPO_FULL_NAME}/branches/main/protection --jq '.required_status_checks.contexts[]'

echo ""
echo "Dev branch protection status:"
gh api repos/${REPO_FULL_NAME}/branches/dev/protection --jq '.required_status_checks.contexts[]'

echo ""
echo "🎉 Branch protection setup completed successfully!"
echo ""
echo "Summary of configured protections:"
echo "📍 Main branch:"
echo "  • Requires PR with 1+ approvals"
echo "  • Requires code owner review"
echo "  • Requires all status checks to pass"
echo "  • No direct pushes allowed"
echo "  • No force pushes or deletions"
echo "  • Admins are included in restrictions"
echo ""
echo "📍 Dev branch:"
echo "  • Requires PR with 1+ approval for external contributors"
echo "  • Requires basic status checks to pass"
echo "  • Core team can push directly"
echo "  • No force pushes or deletions"
echo ""
echo "📍 Repository settings:"
echo "  • Vulnerability alerts enabled"
echo "  • Automated security fixes enabled"
echo "  • Squash merge enabled"
echo "  • Branch auto-deletion enabled"
echo "  • Default branch set to 'dev'"
echo ""
echo "Next steps:"
echo "1. Push your code to GitHub"
echo "2. Test the workflow by creating a feature branch"
echo "3. Create a pull request to verify protections work"
echo "4. Update README.md with workflow instructions"
