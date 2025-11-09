# Git Branch Workflow Rules

## S&H Tech Labs – AI Dental Health Platform

This document outlines the standardized Git branch workflow for the sh-tech-labs repository to ensure consistent development practices and maintain code quality.

## Branch Structure

### Main Branches

#### `main` Branch
- **Purpose**: Production-ready code
- **Protection**: Fully protected - no direct pushes allowed
- **Access**: Only accessible via Pull Request merges
- **Status**: Stable and deployable at all times
- **CI/CD**: Triggers production deployment pipeline

#### `dev` Branch  
- **Purpose**: Development integration branch
- **Protection**: Semi-protected - requires PR for external contributors
- **Access**: Direct pushes allowed for core team members
- **Status**: Latest development features, may be unstable
- **CI/CD**: Triggers staging deployment pipeline

### Feature Branches

#### Naming Convention
```
feature/<descriptive-name>
feature/<issue-number>-<short-description>
feature/user-authentication
feature/123-patient-search-filter
```

#### Usage Guidelines
- Create from `dev` branch
- One feature per branch
- Delete after successful merge
- Keep branch scope focused and small

## Workflow Process

### 1. Feature Development Workflow

```bash
# Start from dev branch
git checkout dev
git pull origin dev

# Create feature branch
git checkout -b feature/patient-dashboard

# Work on feature
git add .
git commit -m "feat: add patient dashboard component"
git push origin feature/patient-dashboard

# Create Pull Request to dev
gh pr create --base dev --title "feat: add patient dashboard component"
```

### 2. Release Workflow

```bash
# Create release branch from dev
git checkout dev
git pull origin dev
git checkout -b release/v1.2.0

# Final testing and bug fixes
git commit -m "fix: minor release issues"
git push origin release/v1.2.0

# Create PR to main
gh pr create --base main --title "release: v1.2.0"

# After merge, tag the release
git checkout main
git pull origin main
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0

# Merge back to dev
git checkout dev
git merge main
git push origin dev
```

### 3. Hotfix Workflow

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-security-fix

# Apply fix
git commit -m "fix: resolve security vulnerability"
git push origin hotfix/critical-security-fix

# Create PR to main
gh pr create --base main --title "hotfix: critical security fix"

# After merge to main, also merge to dev
git checkout dev
git merge main
git push origin dev
```

## Branch Protection Rules

### Main Branch Protection

The `main` branch is protected with the following rules:

#### Required Status Checks
- ✅ All CI/CD pipeline checks must pass
- ✅ Build and test suites must succeed
- ✅ Security scans must pass
- ✅ Code quality checks must pass

#### Pull Request Requirements
- ✅ At least 1 required reviewer
- ✅ Dismiss stale reviews when new commits are pushed
- ✅ Require review from code owners
- ✅ Restrict pushes that create merge conflicts

#### Additional Restrictions
- ❌ No direct pushes allowed
- ❌ No force pushes allowed
- ❌ No deletions allowed
- ✅ Administrators are included in restrictions

### Dev Branch Protection

The `dev` branch has the following protections:

#### Required Status Checks
- ✅ Basic CI checks must pass
- ✅ Automated tests must pass
- ✅ Linting and formatting checks must pass

#### Pull Request Requirements
- ✅ At least 1 reviewer for external contributors
- ✅ Allow core team direct pushes

## Commit Message Standards

### Conventional Commits Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types
- `feat`: New feature
- `fix`: Bug fix  
- `docs`: Documentation changes
- `style`: Code formatting, missing semicolons, etc.
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD configuration changes
- `perf`: Performance improvements
- `build`: Build system changes

### Examples
```bash
feat(auth): add multi-factor authentication support
fix(api): resolve patient data validation error
docs: update API documentation for v2 endpoints
chore: update dependencies to latest versions
ci: add automated security scanning workflow
```

## Pull Request Guidelines

### PR Title Format
Use the same format as commit messages:
```
feat(patient): add patient search functionality
fix(analysis): resolve AI model loading issue
docs: update development setup guide
```

### PR Description Template
```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots to help explain your changes.

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
```

### PR Review Requirements

#### For `dev` branch:
- At least 1 approval from team member
- All automated checks must pass
- No merge conflicts

#### For `main` branch:
- At least 1 approval from code owner/senior developer
- All automated checks must pass
- All required status checks must pass
- No merge conflicts
- Branch must be up to date with main

## Automated Workflows

### GitHub Actions Integration

#### On Push to Feature Branches
```yaml
- Run linting and formatting checks
- Run unit tests
- Run security scans
- Build application
- Deploy to feature environment (optional)
```

#### On PR to Dev
```yaml
- All feature branch checks
- Run integration tests
- Code coverage analysis
- Deploy to staging environment
```

#### On PR to Main
```yaml
- All dev branch checks
- Run full test suite
- Performance testing
- Security audit
- Create release artifacts
- Deploy to production environment
```

## Emergency Procedures

### Critical Hotfix Process
1. Create hotfix branch from `main`
2. Apply minimal fix with thorough testing
3. Create PR with "HOTFIX" label
4. Fast-track review process
5. Deploy immediately after merge
6. Merge changes back to `dev`

### Branch Recovery
If branches become corrupted or need recovery:
1. Contact repository administrator
2. Create backup of current state
3. Use `git reflog` to find last known good state
4. Create recovery branch if needed

## Enforcement

### Automated Enforcement
- Branch protection rules prevent policy violations
- GitHub Actions validate all requirements
- Merge conflicts block PR completion
- Failed status checks prevent merging

### Manual Review Points
- Code quality and architecture review
- Security considerations
- Performance impact assessment
- Documentation completeness
- Test coverage adequacy

## Repository Administrators

### Responsibilities
- Maintain branch protection rules
- Review and update workflow policies
- Handle emergency situations
- Manage repository access permissions
- Monitor workflow compliance

### Contact Information
- **Primary Admin**: S&H Tech Labs Development Team
- **Secondary Admin**: Project Lead
- **Emergency Contact**: DevOps Team

## Workflow Commands Reference

### Quick Reference Commands

```bash
# Setup and branch creation
git checkout dev && git pull origin dev
git checkout -b feature/new-feature

# Development cycle
git add . && git commit -m "feat: add new feature"
git push origin feature/new-feature

# Create PR using GitHub CLI
gh pr create --base dev --title "feat: add new feature" --body "Description of changes"

# Merge and cleanup
gh pr merge --squash  # After PR approval
git branch -d feature/new-feature
```

### Branch Status Commands
```bash
# Check branch protection status
gh api repos/:owner/:repo/branches/main/protection

# List all branches
git branch -a

# Check branch behind/ahead status
git status -sb
```

## Troubleshooting

### Common Issues

#### "Branch protection rules prevent push"
- Solution: Create PR instead of direct push
- Check: Verify you're not pushing to protected branch

#### "Required status checks failed"
- Solution: Fix failing CI/CD checks
- Check: Review GitHub Actions logs for details

#### "Pull request requires review"
- Solution: Request review from team member
- Check: Ensure reviewers have repository access

#### "Branch is out of date"
- Solution: Merge latest changes from target branch
- Command: `git merge origin/dev` or use GitHub's update branch button

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-09 | Initial branch workflow setup |

---

This workflow is designed to maintain code quality, ensure proper testing, and facilitate smooth collaboration among team members. All team members are expected to follow these guidelines consistently.

For questions or workflow improvements, please create an issue in the repository or contact the development team.
