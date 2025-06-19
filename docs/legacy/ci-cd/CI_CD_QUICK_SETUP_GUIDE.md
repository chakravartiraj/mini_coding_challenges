# 🚀 CI/CD Quick Setup Guide

## Overview

This guide provides step-by-step instructions to implement the comprehensive CI/CD pipeline for your Flutter project. Follow these steps to get industry-level CI/CD up and running in under 30 minutes.

## 📋 Prerequisites

- [ ] GitHub repository with Flutter project
- [ ] Admin access to the repository
- [ ] Flutter project with proper `pubspec.yaml`
- [ ] Basic understanding of GitHub Actions

## 🔧 Setup Steps

### Step 1: Copy Workflow Files

Copy the following workflow files to your repository under `.github/workflows/`:

```
.github/
└── workflows/
    ├── ci-cd-main.yml           # Main CI/CD pipeline
    ├── pr-validation.yml        # Pull request validation
    └── performance-monitoring.yml # Performance monitoring
```

### Step 2: Configure Repository Secrets

Go to `Settings` → `Secrets and variables` → `Actions` and add:

#### 🔑 Required Secrets (Minimum Setup)

```bash
# For Android Release Builds (if targeting Android)
ANDROID_KEYSTORE_BASE64=<your-keystore-base64>
ANDROID_KEYSTORE_PASSWORD=<your-keystore-password>
ANDROID_KEY_ALIAS=<your-key-alias>
ANDROID_KEY_PASSWORD=<your-key-password>
```

#### 🔑 Optional Secrets (Enhanced Features)

```bash
# For iOS Builds
IOS_CERTIFICATE_BASE64=<ios-certificate-base64>
IOS_PROVISIONING_PROFILE_BASE64=<provisioning-profile-base64>

# For Notifications
SLACK_WEBHOOK_URL=<slack-webhook-url>

# For Code Coverage
CODECOV_TOKEN=<codecov-token>
```

### Step 3: Set Branch Protection Rules

1. Go to `Settings` → `Branches`
2. Click "Add rule"
3. Branch name pattern: `main`
4. Enable:
   - [x] Require status checks to pass before merging
   - [x] Require pull request reviews before merging
   - [x] Dismiss stale PR reviews when new commits are pushed
   - [x] Require linear history

Required status checks:
- `🔧 Setup & Validation`
- `🔍 Code Quality & Security`
- `⚡ Quick Validation`

### Step 4: Update Project Configuration

#### Update `pubspec.yaml` (if needed)

Ensure your `pubspec.yaml` has the required dependencies:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0  # For linting
  bloc_test: ^9.1.7      # If using BLoC
  mocktail: ^1.0.4       # For testing
```

#### Create/Update `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "build/**"

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: true
    prefer_single_quotes: true
```

### Step 5: Test the Pipeline

1. **Create a test branch**:
   ```bash
   git checkout -b test/ci-cd-setup
   ```

2. **Make a small change** (e.g., update README.md)

3. **Commit and push**:
   ```bash
   git add .
   git commit -m "test: verify CI/CD pipeline setup"
   git push origin test/ci-cd-setup
   ```

4. **Create a Pull Request** and verify:
   - [ ] PR validation workflow runs
   - [ ] All checks pass
   - [ ] No errors in workflow logs

5. **Merge the PR** and verify:
   - [ ] Main CI/CD pipeline runs
   - [ ] All jobs complete successfully

## 📊 Verification Checklist

After setup, verify these items:

### ✅ Workflows Running
- [ ] PR validation runs on pull requests
- [ ] Main pipeline runs on pushes to main/develop
- [ ] Performance monitoring runs (can trigger manually)

### ✅ Code Quality
- [ ] `flutter analyze` passes
- [ ] `dart format` check passes
- [ ] Tests run successfully

### ✅ Build Process
- [ ] Android debug build succeeds
- [ ] Android release build succeeds (if keystore configured)
- [ ] Web build succeeds

### ✅ Security
- [ ] Dependency scanning runs
- [ ] No secrets exposed in logs
- [ ] Proper permissions configured

## 🛠️ Customization Options

### Minimal Setup (Basic CI)

If you want a minimal setup, use only `pr-validation.yml`:

```yaml
# Minimal .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug
```

### Advanced Setup (Full Pipeline)

For full pipeline with all features:
- Copy all three workflow files
- Configure all secrets
- Set up deployment environments
- Enable notifications

## 🚨 Troubleshooting

### Common Issues

1. **Workflow not running**
   - Check workflow file syntax
   - Verify file is in `.github/workflows/`
   - Check repository permissions

2. **Build failures**
   - Check Flutter version compatibility
   - Verify dependencies in `pubspec.yaml`
   - Check for analysis errors

3. **Secret-related errors**
   - Verify secret names match exactly
   - Check secret values are correct
   - Ensure base64 encoding for binary secrets

### Getting Help

1. Check workflow logs in Actions tab
2. Review this documentation
3. Search GitHub Actions documentation
4. Create an issue with logs and error details

## 📈 Next Steps

After successful setup:

1. **Monitor Performance**: Check the performance monitoring dashboard
2. **Optimize Builds**: Review build times and optimize as needed
3. **Add Tests**: Increase test coverage for better quality assurance
4. **Setup Deployments**: Configure deployment to your target platforms
5. **Team Training**: Train team members on the CI/CD workflow

## 🔗 Additional Resources

- [Flutter CI/CD Best Practices](https://flutter.dev/docs/deployment/cd)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

## ⏱️ Expected Timeline

- **Basic Setup**: 15-20 minutes
- **Full Setup with Secrets**: 30-45 minutes
- **Custom Deployment**: 1-2 hours
- **Team Onboarding**: 1-2 days

This setup provides you with a production-ready CI/CD pipeline that follows industry best practices and scales with your team's needs.

# 🚀 CI/CD Quick Setup Guide - Legacy Reference

> **⚠️ Superseded:** This document has been superseded by the main [Quick Setup Guide](../QUICK_SETUP.md)

## 📖 Current Documentation

**For current setup instructions, use:**
- **[Quick Setup](../QUICK_SETUP.md)** - 5-minute setup (main guide)
- **[Complete CI/CD Guide](../CI_CD_PIPELINE_GUIDE.md)** - Full documentation
- **[Implementation Summary](../IMPLEMENTATION_COMPLETE.md)** - What was built

*This file is kept for historical reference only.*
