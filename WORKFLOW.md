# Git Workflow Quick Guide

## 🚀 Getting Started with Development

### 1. Clone and Setup
```bash
git clone https://github.com/yourusername/sh-tech-labs.git
cd sh-tech-labs
npm install
```

### 2. Start Development
```bash
# Always start from dev branch
git checkout dev
git pull origin dev

# Create your feature branch
git checkout -b feature/your-feature-name

# Make your changes and commit
git add .
git commit -m "feat: add your feature description"
git push origin feature/your-feature-name
```

### 3. Create Pull Request
```bash
# Using GitHub CLI (recommended)
gh pr create --base dev --title "feat: your feature description"

# Or visit GitHub web interface
# https://github.com/yourusername/sh-tech-labs/compare/dev...feature/your-feature-name
```

## 🛡️ Branch Protection Rules

- **main** branch: Protected, requires PR with review
- **dev** branch: Semi-protected, requires PR for external contributors  
- **feature/** branches: No restrictions, merge via PR to dev

## 📋 Available Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run test         # Run unit tests
npm run lint         # Check code style
npm run format       # Format code with Prettier
npm run type-check   # TypeScript type checking
```

## 🔄 Workflow Process

1. **Feature Development**: `feature/name` → `dev` (via PR)
2. **Release Preparation**: `dev` → `main` (via PR with review)
3. **Hotfixes**: `hotfix/name` → `main` → merge back to `dev`

For complete workflow documentation, see [.github/branch-rules.md](.github/branch-rules.md).
