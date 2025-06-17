# 🚀 CI/CD Pipeline Setup Guide - Step by Step

## 📋 Prerequisites

Before using this CI/CD pipeline, ensure you have:

- ✅ Flutter SDK installed locally
- ✅ Git repository with Flutter project
- ✅ GitHub repository with Actions enabled
- ✅ Ruby and Bundler (for Fastlane)

## 🔧 Step 1: Initial Setup

### 1.1 Clone and Verify Structure

```bash
# Your project should have this structure
├── .github/workflows/     # ✅ GitHub Actions workflows
├── android/fastlane/      # ✅ Android Fastlane configuration
├── ios/fastlane/          # ✅ iOS Fastlane configuration
├── lib/                   # ✅ Flutter source code
├── test/                  # ✅ Test files
└── pubspec.yaml           # ✅ Flutter dependencies
```

### 1.2 Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# Install Android Fastlane dependencies
cd android && bundle install

# Install iOS Fastlane dependencies (macOS only)
cd ios && bundle install
```

## 🏃‍♂️ Step 2: Test Locally

### 2.1 Run Android Quality Pipeline

```bash
cd android
bundle exec fastlane --file QualityFastfile setup
bundle exec fastlane --file QualityFastfile analyze
bundle exec fastlane --file QualityFastfile test_unit
```

### 2.2 Run iOS Quality Pipeline (macOS only)

```bash
cd ios
bundle exec fastlane --file QualityFastfile setup
bundle exec fastlane --file QualityFastfile analyze
bundle exec fastlane --file QualityFastfile test_unit
```

### 2.3 Full Pipeline Test

```bash
# Android
cd android && bundle exec fastlane --file QualityFastfile master_quality_pipeline

# iOS (macOS only)
cd ios && bundle exec fastlane --file QualityFastfile master_quality_pipeline
```

## 🔐 Step 3: Configure Secrets (Optional)

### 3.1 Basic Setup (No Secrets Required)

The pipeline works out-of-the-box without any secrets for:
- ✅ Static analysis
- ✅ Testing
- ✅ Coverage reporting
- ✅ Performance monitoring
- ✅ Debug build artifacts

### 3.2 Advanced Setup (With Secrets)

For release builds and distribution, add these secrets:

1. **Go to GitHub Repository Settings**
2. **Navigate to Secrets and Variables → Actions**
3. **Add the following secrets**:

```bash
# Android Release Signing
ANDROID_KEYSTORE_BASE64="<base64-encoded-keystore>"
ANDROID_STORE_PASSWORD="your-store-password"
ANDROID_KEY_PASSWORD="your-key-password"
ANDROID_KEY_ALIAS="your-key-alias"

# Firebase Distribution (Optional)
FIREBASE_APP_ID_ANDROID="1:123456789:android:abcdef"
FIREBASE_TOKEN="your-firebase-token"

# Notifications (Optional)
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/..."
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

**📖 Detailed Secret Setup**: See [`GITHUB_SECRETS_SETUP.md`](GITHUB_SECRETS_SETUP.md)

## 📊 Step 4: Understanding the Pipeline

### 4.1 Pipeline Triggers

The pipeline automatically runs on:
- ✅ **Push to main/develop**: Full quality pipeline
- ✅ **Pull Requests**: Validation pipeline
- ✅ **Manual dispatch**: On-demand execution

### 4.2 Quality Gates

Each run checks:
- 🔍 **Static Analysis**: Code quality and security
- 🧪 **Testing**: Unit, widget, integration, golden tests
- 📊 **Coverage**: Test coverage analysis
- ⚡ **Performance**: Build time and app size monitoring
- 🔨 **Build**: Artifact generation

### 4.3 Artifacts Generated

After each run, you'll find:
- 📈 **Quality Reports**: Analysis and metrics
- 🧪 **Test Results**: Detailed test output
- 📊 **Coverage Reports**: HTML and LCOV formats
- ⚡ **Performance Data**: Build and size metrics
- 🔨 **Build Artifacts**: APK, AAB, IPA files

## 🎯 Step 5: First Pipeline Run

### 5.1 Trigger First Run

```bash
# Make a small change to trigger the pipeline
echo "# CI/CD Pipeline Active" >> README.md
git add README.md
git commit -m "feat: activate CI/CD pipeline"
git push origin main
```

### 5.2 Monitor Pipeline

1. **Go to GitHub Actions tab**
2. **Click on "Flutter CI/CD Pipeline"**
3. **Watch the pipeline execute**

Expected timeline:
- ⚡ **Setup**: 2-3 minutes
- 🔍 **Quality Analysis**: 3-5 minutes
- 🧪 **Testing**: 5-10 minutes
- 📊 **Coverage**: 2-3 minutes
- ⚡ **Performance**: 3-5 minutes
- 🔨 **Build**: 5-10 minutes
- **Total**: 20-35 minutes

### 5.3 Review Results

After completion, check:
- ✅ **Pipeline Status**: Green checkmark
- 📊 **Quality Summary**: In Actions summary
- 📁 **Artifacts**: Download reports and builds
- 🔍 **Logs**: Detailed execution logs

## 🎨 Step 6: Customization

### 6.1 Adjust Quality Thresholds

Edit `android/fastlane/QualityFastfile`:

```ruby
# Coverage threshold
lane :coverage_report do
  # ... existing code ...
  
  # Set your coverage threshold
  minimum_coverage = 80  # Adjust this value
  
  if coverage_percent < minimum_coverage
    UI.important "⚠️ Coverage below threshold: #{coverage_percent}%"
    # UI.user_error! "Coverage too low" # Uncomment to fail
  end
end
```

### 6.2 Performance Limits

```ruby
# App size limits
lane :performance_monitoring do
  # ... existing code ...
  
  # Set your app size limits
  max_apk_size_mb = 50  # Adjust this value
  
  if apk_size_mb > max_apk_size_mb
    UI.important "⚠️ APK size exceeded: #{apk_size_mb}MB"
    # UI.user_error! "APK too large" # Uncomment to fail
  end
end
```

### 6.3 Test Configuration

```ruby
# Custom test paths
lane :test_unit do
  # Add your test directories
  test_dirs = [
    "test/unit",
    "test/models", 
    "test/services",
    # Add more as needed
  ]
  
  test_dirs.each do |dir|
    if Dir.exist?("../#{dir}")
      sh("cd .. && flutter test #{dir} --coverage")
    end
  end
end
```

## 📱 Step 7: Platform-Specific Setup

### 7.1 Android-Only Projects

If you only need Android:
- ✅ Use `ci-cd-main.yml` workflow
- ✅ Focus on `android/fastlane/QualityFastfile`
- ✅ Skip iOS-specific configurations

### 7.2 iOS-Only Projects

If you only need iOS:
- ✅ Use `ios-quality.yml` workflow
- ✅ Focus on `ios/fastlane/QualityFastfile`
- ✅ Ensure macOS runner availability

### 7.3 Multi-Platform Projects

For both platforms:
- ✅ Use both workflows
- ✅ Configure both Fastlane files
- ✅ Manage platform-specific secrets

## 🔧 Step 8: Troubleshooting

### 8.1 Common Issues

**Issue**: Bundle install fails
```bash
# Solution
cd android
rm Gemfile.lock
bundle install
```

**Issue**: Flutter analyze fails
```bash
# Solution
dart fix --apply
dart format .
```

**Issue**: Tests not found
```bash
# Solution: Create test directory structure
mkdir -p test/unit test/widget test/integration test/golden
```

### 8.2 Debug Mode

Add debug logging to `QualityFastfile`:

```ruby
# At the top of any lane
puts "🐛 DEBUG: Starting #{lane_context[:LANE_NAME]}"
puts "🐛 DEBUG: Current directory: #{Dir.pwd}"
puts "🐛 DEBUG: Files in directory: #{Dir.entries('.')}"
```

### 8.3 Getting Help

1. **Check Pipeline Logs**: Detailed error messages
2. **Review Documentation**: All guides in `docs/ci-cd/`
3. **Test Locally**: Run Fastlane commands locally
4. **Check Dependencies**: Ensure all tools installed

## 🎉 Step 9: Success Checklist

After setup, verify:

- ✅ **Pipeline runs successfully** on push/PR
- ✅ **Quality reports generated** in artifacts
- ✅ **Test results available** in pipeline output
- ✅ **Coverage reports created** with HTML output
- ✅ **Build artifacts generated** (APK/AAB/IPA)
- ✅ **Performance metrics collected** and stored
- ✅ **Quality gates enforced** according to your thresholds

## 🚀 Step 10: Next Steps

1. **🎯 Fine-tune thresholds** based on your project needs
2. **📊 Add custom metrics** for specific requirements
3. **🔔 Setup notifications** for team collaboration
4. **🎨 Expand testing** with more comprehensive test suites
5. **📈 Monitor trends** in quality metrics over time

## 💡 Pro Tips

- **🔄 Start with lenient thresholds** and gradually increase them
- **📊 Use coverage reports** to identify untested code
- **⚡ Monitor build times** to optimize pipeline performance
- **🎯 Focus on critical paths** for golden tests
- **🔍 Review static analysis** warnings regularly

Your CI/CD pipeline is now ready for production use! 🎉

---

For more detailed information, see:
- [`PIPELINE_IMPLEMENTATION.md`](PIPELINE_IMPLEMENTATION.md) - Complete implementation guide
- [`GITHUB_SECRETS_SETUP.md`](GITHUB_SECRETS_SETUP.md) - Secret management
- [`QUALITY_FIRST_PIPELINE.md`](QUALITY_FIRST_PIPELINE.md) - Pipeline philosophy
