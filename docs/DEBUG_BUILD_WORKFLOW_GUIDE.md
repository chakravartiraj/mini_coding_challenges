# 🚀 Debug Build Workflow Documentation

## Overview

The Debug Build workflow automatically generates debug APK and App Bundle artifacts with industry-standard dynamic versioning. This workflow is designed for development, testing, and internal distribution purposes.

## 🎯 Features

### **Dynamic Versioning**
- **Timestamp-based builds**: `YYYYMMDDHHMM` format
- **Git-aware versioning**: Includes branch and commit information
- **GitHub Actions integration**: Uses run number for build codes
- **Custom suffixes**: Optional version suffixes via manual triggers

### **Artifacts Generated**
- **Debug APK**: Ready for direct installation and testing
- **Debug App Bundle**: For testing bundle-specific functionality
- **Build Metadata**: JSON file with complete build information
- **Build Information**: Detailed build context and environment

### **Version Format**
```
Format: {major}.{minor}.{patch}-{context}-{commit}
Examples:
  - Main branch: 1.0.0-debug-a1b2c3d
  - Feature branch: 1.0.0-featureauth-a1b2c3d
  - With suffix: 1.0.0-debug-a1b2c3d-hotfix
```

## 🚀 Workflow Triggers

### **Automatic Triggers**
```yaml
# Push to main branches
on:
  push:
    branches: [ main, develop, feature/* ]
  
# Pull requests
  pull_request:
    branches: [ main, develop ]
```

### **Manual Trigger**
```yaml
# Manual dispatch with options
workflow_dispatch:
  inputs:
    build_type:
      description: 'Build type'
      default: 'debug'
      options: [ debug, release ]
    version_suffix:
      description: 'Version suffix (optional)'
      type: string
```

## 📱 Usage Examples

### **1. Automatic Build (Push)**
```bash
# Push to any tracked branch triggers build
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature
# → Generates: 1.0.0-featurenewfeature-a1b2c3d
```

### **2. Manual Build with Custom Suffix**
1. Go to **Actions** → **Debug Build with Dynamic Versioning**
2. Click **Run workflow**
3. Select branch and enter optional suffix
4. Artifacts generated with custom version

### **3. Local Development**
```bash
# Run locally with same versioning
./scripts/build-debug-local.sh

# With custom suffix
./scripts/build-debug-local.sh hotfix
```

## 📦 Artifacts Structure

### **APK Artifact**
```
debug-apk-{version}/
├── app-debug.apk           # Installable APK
└── build_metadata.json     # Build information
```

### **App Bundle Artifact**
```
debug-aab-{version}/
├── app-debug.aab           # App Bundle
└── build_metadata.json     # Build information
```

### **Build Info Artifact**
```
build-info-{version}/
├── build_metadata.json     # Workflow metadata
└── build_info.json        # Fastlane build info
```

## 🔧 Build Metadata

Each artifact includes comprehensive build metadata:

```json
{
  "version_name": "1.0.0-debug-a1b2c3d",
  "version_code": 42,
  "build_time": "2025-06-18T10:30:45.123Z",
  "git_branch": "main",
  "git_commit": "a1b2c3d",
  "git_commit_full": "a1b2c3d4e5f6789...",
  "workflow_run": 42,
  "workflow_url": "https://github.com/.../actions/runs/123",
  "build_type": "debug",
  "flutter_version": "3.24.3",
  "java_version": "17"
}
```

## 🎯 Fastlane Integration

### **New Lanes Added**
```ruby
# Main build lane with dynamic versioning
fastlane build_debug_artifacts

# Helper lanes
fastlane generate_dynamic_version    # Version generation
fastlane create_build_info          # Build metadata
```

### **Dynamic Version Logic**
1. **Get git information**: Branch, commit hash
2. **Generate timestamp**: `YYYYMMDDHHMM` format
3. **Create version name**: Based on branch and commit
4. **Set build number**: GitHub run number or timestamp
5. **Build with versions**: Apply to both APK and AAB

## 📊 Workflow Performance

### **Typical Timing**
- **Setup**: ~2-3 minutes (Flutter, Java, Ruby)
- **Dependencies**: ~1-2 minutes (pub get, bundle install)
- **Build**: ~5-10 minutes (APK + AAB generation)
- **Upload**: ~1-2 minutes (artifact upload)
- **Total**: ~10-15 minutes

### **Optimization Features**
- **Caching**: Flutter SDK and dependencies cached
- **Parallel execution**: Independent artifact uploads
- **Smart timeouts**: 45-minute maximum runtime
- **Compression**: Level 6 for smaller artifacts

## 🔧 Customization

### **Version Format Customization**
Edit in `.github/workflows/debug-build.yml`:
```yaml
# Modify version generation logic
MAJOR_MINOR_PATCH="2.1.0"  # Update base version
VERSION_NAME="${MAJOR_MINOR_PATCH}-${BUILD_TYPE}-${GIT_COMMIT}"
```

### **Fastlane Customization**
Edit `android/fastlane/Fastfile`:
```ruby
# Customize build process
lane :build_debug_artifacts do |options|
  # Add custom pre-build steps
  setup
  run_tests if options[:run_tests]
  
  # Custom build logic
  sh("cd .. && flutter build apk --debug --build-name=#{version_name}")
end
```

### **Artifact Retention**
```yaml
# Adjust retention periods
retention-days: 30  # APK/AAB artifacts
retention-days: 90  # Build information
```

## 🚀 Integration Examples

### **CI/CD Pipeline Integration**
```yaml
# Use in other workflows
- name: Build Debug Artifacts
  uses: ./.github/workflows/debug-build.yml
  with:
    version_suffix: ${{ github.event.inputs.suffix }}
```

### **Download and Test**
```bash
# Download from GitHub Actions
gh run download $RUN_ID --name "debug-apk-1.0.0-debug-a1b2c3d"

# Install and test
adb install app-debug.apk
adb shell am start -n com.example.app/.MainActivity
```

### **Automated Testing Integration**
```yaml
# Test workflow after build
needs: debug-build
steps:
  - name: Download APK
    uses: actions/download-artifact@v4
  - name: Run UI Tests
    run: ./test-scripts/ui-tests.sh app-debug.apk
```

## 📋 Best Practices

### **Version Management**
- Use **semantic versioning** for base version
- Include **branch context** for feature builds
- Add **commit hashes** for traceability
- Use **build numbers** for ordering

### **Artifact Management**
- **30-day retention** for build artifacts
- **90-day retention** for build metadata
- **Descriptive names** with version information
- **Compressed uploads** for efficiency

### **Security Considerations**
- Debug builds only (no release secrets required)
- Public artifact access (consider for private repos)
- No sensitive information in version names
- Regular cleanup of old artifacts

## 🔍 Troubleshooting

### **Common Issues**

**Build Failures**
```bash
# Check Flutter doctor
flutter doctor -v

# Verify Fastlane setup
cd android && bundle exec fastlane --version
```

**Version Conflicts**
```bash
# Clean build environment
flutter clean
cd android && ./gradlew clean
```

**Artifact Upload Issues**
- Check GitHub storage limits
- Verify workflow permissions
- Review artifact name conflicts

### **Debug Information**
- **Workflow logs**: Full GitHub Actions output
- **Build metadata**: Detailed build context
- **Fastlane reports**: Ruby execution details
- **Flutter doctor**: Environment verification

This workflow provides a production-ready solution for automated debug builds with comprehensive versioning, artifact management, and integration capabilities.
