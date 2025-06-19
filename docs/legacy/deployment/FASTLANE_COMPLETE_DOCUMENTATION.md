# 🚀 Fastlane Integration - Complete Documentation

## Overview

This document provides comprehensive documentation for the Fastlane integration in the Mini Coding Challenges Flutter project. Fastlane automates the entire build, test, and deployment process for both Android and iOS platforms, providing industry-level efficiency and seamless workflows.

## 📋 Table of Contents

1. [Features & Capabilities](#features--capabilities)
2. [Architecture Overview](#architecture-overview)
3. [Setup & Installation](#setup--installation)
4. [Environment Configuration](#environment-configuration)
5. [Available Lanes](#available-lanes)
6. [CI/CD Integration](#cicd-integration)
7. [Deployment Workflows](#deployment-workflows)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)

## 🎯 Features & Capabilities

### Automated Workflows
- **Multi-platform deployment** (Android & iOS)
- **Multi-environment support** (dev, staging, production)
- **Automated code signing** for iOS
- **Firebase App Distribution** integration
- **Google Play Console** and **App Store Connect** uploads
- **Version management** and changelog generation
- **Quality gates** and testing integration
- **Slack notifications** and reporting

### Build Configurations
- **Android**: APK and AAB builds with flavors
- **iOS**: IPA builds with proper code signing
- **Environment-specific** configurations
- **Automated versioning** with semantic versioning
- **Build artifact management**

### Quality Assurance
- **Code formatting** validation
- **Static analysis** with flutter analyze
- **Comprehensive testing** suite execution
- **Coverage reporting**
- **Security scanning** integration

## 🏗️ Architecture Overview

### Project Structure
```
mini_coding_challenges/
├── fastlane/
│   ├── Fastfile                 # Main Fastlane configuration
│   └── Appfile                  # App Store Connect API configuration
├── android/
│   └── fastlane/
│       ├── Appfile              # Android-specific configuration
│       └── Fastfile -> ../fastlane/Fastfile
├── ios/
│   └── fastlane/
│       ├── Appfile              # iOS-specific configuration
│       ├── Gymfile              # iOS build configuration
│       ├── Matchfile            # Code signing configuration
│       └── Fastfile -> ../fastlane/Fastfile
├── lib/
│   ├── main.dart                # Default main file
│   ├── main_dev.dart            # Development environment
│   ├── main_staging.dart        # Staging environment
│   └── main_production.dart     # Production environment
└── .github/workflows/
    └── fastlane-deployment.yml  # GitHub Actions integration
```

### Environment Flow
```
Development (dev)     → Firebase App Distribution → Internal Testing
Staging (staging)     → Firebase App Distribution → Beta Testing  
Production (production) → App Stores → Public Release
```

## ⚙️ Setup & Installation

### Prerequisites

1. **Ruby 3.1+** installed
2. **Bundler** gem installed
3. **Flutter SDK** configured
4. **Android Studio** and **Xcode** (for respective platforms)
5. **Git** configured for version control

### Installation Steps

#### 1. Install Ruby Dependencies
```bash
# Install bundler if not already installed
gem install bundler

# Install fastlane and plugins
bundle install
```

#### 2. Environment Variables Setup

Create a `.env` file (or set in CI/CD secrets):

```bash
# Required for all environments
FLUTTER_VERSION=3.16.0

# Android Configuration
ANDROID_KEYSTORE_PASSWORD=your_keystore_password
ANDROID_KEY_ALIAS=your_key_alias
ANDROID_KEY_PASSWORD=your_key_password
GOOGLE_PLAY_JSON_KEY_PATH=/path/to/google-play-service-account.json

# iOS Configuration
APPLE_ID=your_apple_id@example.com
APPLE_TEAM_ID=YOUR_TEAM_ID
APP_STORE_CONNECT_API_KEY_ID=YOUR_API_KEY_ID
APP_STORE_CONNECT_ISSUER_ID=YOUR_ISSUER_ID
APP_STORE_CONNECT_API_KEY_PATH=/path/to/api-key.p8
MATCH_GIT_URL=https://github.com/your-org/certificates.git
MATCH_PASSWORD=your_match_password

# Firebase Configuration
FIREBASE_APP_ID_ANDROID=1:123456789:android:abcdef
FIREBASE_APP_ID_IOS=1:123456789:ios:abcdef
FIREBASE_SERVICE_ACCOUNT_KEY_PATH=/path/to/firebase-service-account.json

# Notifications
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

#### 3. iOS Code Signing Setup

```bash
# Initialize match for the first time
cd ios
bundle exec fastlane match init

# Generate certificates and profiles
bundle exec fastlane match development
bundle exec fastlane match adhoc
bundle exec fastlane match appstore
```

#### 4. Android Keystore Setup

```bash
# Generate keystore (if you don't have one)
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias mini-coding-challenges

# Create key.properties file
cat > android/key.properties << EOF
storePassword=your_password
keyPassword=your_password
keyAlias=mini-coding-challenges
storeFile=keystore.jks
EOF
```

## 🌍 Environment Configuration

### Environment-Specific Settings

#### Development Environment
- **Purpose**: Internal development and testing
- **Distribution**: Firebase App Distribution to developers
- **Features**: Debug builds, development API endpoints, visible debug banner
- **Color Theme**: Orange

#### Staging Environment  
- **Purpose**: QA testing and client demos
- **Distribution**: Firebase App Distribution to testers
- **Features**: Release builds, staging API endpoints, testing features enabled
- **Color Theme**: Purple

#### Production Environment
- **Purpose**: Public release
- **Distribution**: App stores (Google Play, App Store)
- **Features**: Optimized release builds, production API endpoints, analytics enabled
- **Color Theme**: Deep Purple

### Flutter Environment Files

Each environment has its own main file:

```dart
// lib/main_dev.dart
void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'dev'));
}

// lib/main_staging.dart  
void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'staging'));
}

// lib/main_production.dart
void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'production'));
}
```

## 🛣️ Available Lanes

### Cross-Platform Lanes

#### Quality Check
```bash
bundle exec fastlane quality_check
```
**Purpose**: Run comprehensive quality checks
- Code formatting validation
- Static analysis with flutter analyze
- Test suite execution
- Coverage reporting

#### Version Management
```bash
# Bump patch version (1.0.0 → 1.0.1)
bundle exec fastlane bump_version

# Bump minor version (1.0.0 → 1.1.0)
bundle exec fastlane bump_version type:minor

# Bump major version (1.0.0 → 2.0.0)
bundle exec fastlane bump_version type:major
```

#### Clean Build
```bash
bundle exec fastlane clean_build
```
**Purpose**: Clean all build artifacts and caches

### Android Lanes

#### Development Build
```bash
cd android
bundle exec fastlane dev
```
**Features**:
- Debug APK build
- Firebase App Distribution to developers
- Development configuration

#### Staging Build
```bash
cd android
bundle exec fastlane staging
```
**Features**:
- Release APK and AAB builds
- Firebase App Distribution to testers
- Staging configuration

#### Production Build
```bash
cd android
bundle exec fastlane production
```
**Features**:
- Release AAB build
- Upload to Google Play Internal Testing
- Production configuration
- Automated versioning

#### Beta Release
```bash
cd android
bundle exec fastlane beta
```
**Features**:
- Upload to Google Play Beta track
- Beta tester distribution

#### Promote to Production
```bash
cd android
bundle exec fastlane promote_to_production
```
**Features**:
- Promote from internal to production track
- No new build required

### iOS Lanes

#### Development Build
```bash
cd ios
bundle exec fastlane dev
```
**Features**:
- Debug IPA build
- Development code signing
- Firebase App Distribution to developers

#### Staging Build
```bash
cd ios
bundle exec fastlane staging
```
**Features**:
- Release IPA build
- Ad-hoc code signing
- Firebase App Distribution to testers

#### Production Build
```bash
cd ios
bundle exec fastlane production
```
**Features**:
- Release IPA build
- App Store code signing
- Upload to TestFlight
- Production configuration

#### Beta Release
```bash
cd ios
bundle exec fastlane beta
```
**Features**:
- Upload to TestFlight Beta
- Beta tester distribution

#### App Store Release
```bash
cd ios
bundle exec fastlane release
```
**Features**:
- Upload to App Store for review
- Production release

### Utility Lanes

#### Setup Code Signing
```bash
bundle exec fastlane setup_code_signing
```
**Purpose**: Initialize iOS code signing certificates

#### Generate Screenshots
```bash
bundle exec fastlane screenshots
```
**Purpose**: Generate app store screenshots

#### Update Metadata
```bash
bundle exec fastlane update_metadata
```
**Purpose**: Update app store metadata

## 🔄 CI/CD Integration

### GitHub Actions Workflow

The Fastlane integration includes a comprehensive GitHub Actions workflow:

#### Triggers
- **Push** to main/develop branches
- **Tagged releases** (v*)
- **Manual dispatch** with custom parameters
- **Pull requests** (validation only)

#### Workflow Features
- **Multi-platform deployment** (Android & iOS)
- **Environment-specific builds** based on branch
- **Parallel execution** for efficiency
- **Artifact preservation** for debugging
- **Slack notifications** for team awareness
- **Deployment summaries** and reporting

#### Branch Strategy
```
develop → Development environment (dev)
main    → Staging environment (staging)  
tags    → Production environment (production)
```

### Manual Deployment

You can trigger deployments manually through GitHub Actions:

1. Go to **Actions** → **Fastlane Deployment Pipeline**
2. Click **Run workflow**
3. Select:
   - **Platform**: android, ios, or both
   - **Environment**: dev, staging, or production
   - **Lane**: (optional) specific lane to run

### Local Development

For local testing and development:

```bash
# Test development build locally
bundle exec fastlane android dev

# Test staging build locally  
bundle exec fastlane ios staging

# Run quality checks
bundle exec fastlane quality_check
```

## 🚀 Deployment Workflows

### Development Workflow
```
Code → Push to develop → CI checks → Fastlane dev → Firebase Distribution
```

1. **Developer pushes** to develop branch
2. **CI pipeline** runs quality checks
3. **Fastlane dev lane** builds and distributes
4. **Developers receive** notification with download link

### Staging Workflow
```
Code → Merge to main → CI checks → Fastlane staging → Firebase Distribution
```

1. **PR merged** to main branch
2. **CI pipeline** runs comprehensive checks
3. **Fastlane staging lane** builds and distributes
4. **QA team receives** notification for testing

### Production Workflow
```
Code → Create tag → CI checks → Fastlane production → App Stores
```

1. **Release tag** created (e.g., v1.0.0)
2. **CI pipeline** runs full validation
3. **Fastlane production lane** builds and uploads
4. **Apps available** in TestFlight/Internal Testing
5. **Manual promotion** to production when ready

### Emergency Hotfix Workflow
```
Hotfix → Direct main push → Fast-track staging → Quick production release
```

1. **Critical fix** pushed directly to main
2. **Expedited CI** with essential checks only
3. **Staging deployment** for quick verification
4. **Production release** with accelerated timeline

## 🔧 Troubleshooting

### Common Issues

#### Android Build Failures

**Issue**: Keystore not found
```
Execution failed for task ':app:validateSigningRelease'
```

**Solution**:
```bash
# Verify keystore exists
ls -la android/app/keystore.jks

# Check key.properties
cat android/key.properties

# Regenerate if necessary
keytool -genkey -v -keystore android/app/keystore.jks ...
```

**Issue**: Gradle build failure
```
What went wrong: Execution failed for task ':app:processReleaseGoogleServices'
```

**Solution**:
```bash
# Clean and rebuild
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### iOS Build Failures

**Issue**: Code signing errors
```
No profiles for 'com.example.miniCodingChallenges' were found
```

**Solution**:
```bash
# Refresh certificates
cd ios
bundle exec fastlane match development --force
bundle exec fastlane match appstore --force
```

**Issue**: Xcode build failure
```
xcodebuild: error: Unable to find a destination matching the provided destination specifier
```

**Solution**:
```bash
# List available simulators
xcrun simctl list devices

# Update Xcode command line tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### Fastlane Issues

**Issue**: Bundle install failures
```
An error occurred while installing ffi (1.15.5)
```

**Solution**:
```bash
# Install native dependencies
sudo apt-get install build-essential  # Ubuntu/Debian
brew install libffi                   # macOS

# Reinstall gems
bundle install
```

**Issue**: Firebase authentication
```
ERROR: Service account key is not valid
```

**Solution**:
```bash
# Verify service account key
cat firebase-service-account.json | jq .

# Set correct environment variable
export GOOGLE_APPLICATION_CREDENTIALS=path/to/firebase-service-account.json
```

### Debug Mode

Enable verbose logging for troubleshooting:

```bash
# Add to Fastfile before action
puts "🔍 Debug: Current directory is #{Dir.pwd}"
puts "🔍 Debug: Environment variables: #{ENV.to_h}"

# Run with verbose output
bundle exec fastlane android dev --verbose
```

### Log Analysis

Check logs in the following locations:

- **Fastlane logs**: `fastlane/logs/`
- **Android build logs**: `android/app/build/outputs/logs/`
- **iOS build logs**: `ios/build/Logs/`
- **CI logs**: GitHub Actions workflow logs

## 📝 Best Practices

### Security

1. **Never commit secrets** to version control
2. **Use environment variables** for sensitive data
3. **Rotate API keys** regularly
4. **Enable 2FA** on all developer accounts
5. **Use match** for iOS code signing consistency

### Performance

1. **Use caching** for dependencies and build artifacts
2. **Parallelize builds** when possible
3. **Clean builds** regularly to avoid issues
4. **Monitor build times** and optimize bottlenecks
5. **Use incremental builds** in development

### Maintenance

1. **Update Fastlane** and plugins regularly
2. **Monitor deprecation warnings**
3. **Review and update** certificates before expiration
4. **Test deployment process** in staging environment
5. **Document customizations** and team-specific workflows

### Team Workflow

1. **Establish clear** deployment responsibilities
2. **Use consistent** environment naming
3. **Document emergency** procedures
4. **Train team members** on Fastlane usage
5. **Monitor deployment** metrics and success rates

### Quality Assurance

1. **Always run** quality checks before deployment
2. **Test in staging** before production release
3. **Maintain high** test coverage
4. **Use feature flags** for risk mitigation
5. **Monitor app** performance post-deployment

## 📊 Monitoring & Analytics

### Key Metrics

Track these metrics for deployment health:

- **Build success rate** (target: >95%)
- **Average build time** (target: <20 minutes)
- **Deployment frequency** (target: daily for dev)
- **Time to production** (target: <2 hours for hotfixes)
- **Rollback rate** (target: <5%)

### Alerts and Notifications

Set up alerts for:

- **Build failures** → Immediate Slack notification
- **Certificate expiration** → 30-day advance warning
- **Large app size increases** → Size analysis report
- **Performance regressions** → Automated rollback trigger

### Reporting

Generate weekly reports on:

- Deployment frequency and success rates
- Build time trends
- Quality gate metrics
- Team productivity metrics

## 🎓 Advanced Usage

### Custom Lanes

Create project-specific lanes:

```ruby
# Custom lane for feature branch testing
lane :feature_test do |options|
  branch = options[:branch] || git_branch
  
  # Build with feature configuration
  sh("flutter", "build", "apk", "--debug", "--dart-define=FEATURE_BRANCH=#{branch}")
  
  # Distribute to feature testers
  firebase_app_distribution(
    app: ENV["FIREBASE_APP_ID_ANDROID"],
    apk_path: "build/app/outputs/flutter-apk/app-debug.apk",
    groups: "feature-testers",
    release_notes: "Feature branch: #{branch}"
  )
end
```

### Integration with External Services

#### Sentry Integration
```ruby
# Upload dSYMs to Sentry
after_all do |lane|
  if lane.to_s.include?("production")
    upload_symbols_to_sentry(
      auth_token: ENV["SENTRY_AUTH_TOKEN"],
      org_slug: "your-org",
      project_slug: "mini-coding-challenges"
    )
  end
end
```

#### Slack Integration
```ruby
# Custom Slack messages
slack(
  message: "🚀 #{PROJECT_NAME} v#{get_version_number} deployed to production!",
  channel: "#releases",
  payload: {
    "Environment" => "Production",
    "Build Number" => get_build_number,
    "Git Commit" => last_git_commit[:commit_hash]
  }
)
```

### Automation Scripts

#### Weekly Certificate Check
```bash
#!/bin/bash
# scripts/check-certificates.sh

echo "🔍 Checking certificate expiration..."

cd ios
bundle exec fastlane match doctor

if [ $? -ne 0 ]; then
    echo "⚠️ Certificate issues found!"
    # Send alert
    curl -X POST -H 'Content-type: application/json' \
        --data '{"text":"⚠️ iOS certificates need attention!"}' \
        $SLACK_WEBHOOK_URL
fi
```

#### Automated Version Updates
```bash
#!/bin/bash
# scripts/weekly-version-bump.sh

echo "📈 Performing weekly version bump..."

# Bump version
bundle exec fastlane bump_version type:patch

# Create PR for version update
gh pr create --title "chore: weekly version bump" \
              --body "Automated weekly version increment"
```

This comprehensive Fastlane integration provides industry-level automation for your Flutter project, ensuring consistent, reliable, and efficient deployment workflows across all environments and platforms.
