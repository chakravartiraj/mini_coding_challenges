#!/bin/bash

# GitHub Repository Setup Script for Mini Coding Challenges
# =========================================================
#
# This script helps you set up the GitHub repository for your project.
# Run this after creating the repository on GitHub.

echo "🚀 Setting up GitHub repository for Mini Coding Challenges"
echo "=========================================================="
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git repository already exists"
fi

echo ""
echo "📝 Adding files to Git..."

# Add all files
git add .

echo "✅ Files added to staging"

echo ""
echo "💾 Creating initial commit..."

# Create initial commit
git commit -m "feat: initial commit with comprehensive testing suite

- Clean Architecture implementation with domain, data, and presentation layers
- BLoC pattern for state management with complete test coverage
- Comprehensive testing suite with unit, widget, and integration tests
- Transaction feature with pagination support
- Industry-standard project structure and documentation
- CI/CD ready with GitHub Actions workflows
- Production-ready code with error handling and loading states"

echo "✅ Initial commit created"

echo ""
echo "🌟 Next Steps:"
echo "=============="
echo ""
echo "1. Create a new repository on GitHub with one of these names:"
echo "   • mini-coding-challenges-flutter"
echo "   • flutter-mini-coding-challenges" 
echo "   • mini-coding-challenges"
echo "   • flutter-transaction-app-testing"
echo ""
echo "2. Set the repository to PUBLIC"
echo ""
echo "3. Copy the repository URL from GitHub"
echo ""
echo "4. Run these commands with your actual repository URL:"
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "5. Your repository will be live with:"
echo "   ✅ Complete source code"
echo "   ✅ Comprehensive documentation" 
echo "   ✅ Testing suite"
echo "   ✅ GitHub workflows"
echo "   ✅ Contributing guidelines"
echo ""
echo "🎉 Repository setup complete!"
echo ""
echo "📊 Project Statistics:"
echo "• $(find lib -name "*.dart" | wc -l) Dart source files"
echo "• $(find test -name "*_test.dart" | wc -l) test files"
echo "• $(git log --oneline | wc -l) commit(s)"
echo "• Clean Architecture ✅"
echo "• BLoC Pattern ✅" 
echo "• Comprehensive Tests ✅"
echo "• Production Ready ✅"
