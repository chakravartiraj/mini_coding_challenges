# 🚀 Deployment Guide

> **How to release the Mini Coding Challenges app to app stores and users**

## 🎯 Deployment Overview

Deploy your app to:
- **Google Play Store** (Android)
- **Apple App Store** (iOS) 
- **Direct distribution** (APK files)
- **Internal testing** (Beta releases)

## 📋 Before You Deploy

### **Required Setup**
1. **[Android signing configured](../build/ANDROID_SIGNING.md)** - Keystore ready
2. **Release builds working** - `flutter build appbundle --release`
3. **Tests passing** - All tests green
4. **Store accounts** - Google Play, App Store accounts

### **Pre-deployment Checklist**
- [ ] **App icon** - High resolution app icon
- [ ] **App name** - Final app name decided
- [ ] **Version bumped** - Updated in pubspec.yaml
- [ ] **Privacy policy** - Required for store submission
- [ ] **App description** - Store listing content
- [ ] **Screenshots** - Device screenshots for store

## 🤖 Google Play Store (Android)

### **1. Build App Bundle**
```bash
# Build optimized App Bundle
flutter build appbundle --release

# Verify signing
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

### **2. Google Play Console Setup**
1. **Create app** in Google Play Console
2. **Upload App Bundle** - Use the .aab file
3. **Complete store listing** - Description, screenshots, etc.
4. **Set up releases** - Choose release track (internal/alpha/beta/production)

### **3. Release Process**
```bash
# Build for production
flutter build appbundle --release

# Upload to Play Console
# Manual upload or use Fastlane (see below)
```

### **4. Automated Deployment with Fastlane**
```bash
cd android
bundle exec fastlane deploy_to_play_store
```

## 🍎 Apple App Store (iOS)

### **1. Build iOS App**
```bash
# Build iOS release
flutter build ios --release

# Or build iOS archive
flutter build ipa --release
```

### **2. App Store Connect Setup**
1. **Create app** in App Store Connect
2. **Upload with Xcode** or Transporter
3. **Complete metadata** - App information
4. **Submit for review** - Apple review process

### **3. TestFlight Beta Testing**
```bash
# Build and upload to TestFlight
flutter build ipa --release
# Upload via Xcode or fastlane
```

## 📱 Direct Distribution (APK)

### **Build APK for Direct Install**
```bash
# Build signed APK
flutter build apk --release

# Share APK file
# Location: build/app/outputs/flutter-apk/app-release.apk
```

### **Distribution Methods**
- **Email/messaging** - Send APK file directly
- **Cloud storage** - Upload to Drive, Dropbox, etc.
- **Internal servers** - Host on company servers
- **QR codes** - Generate QR code for easy install

## 🎮 Beta Testing

### **Internal Testing**
```bash
# Build debug version for team testing
./scripts/build-debug-local.sh

# Build release version for stakeholder testing  
./scripts/build-release-local.sh
```

### **External Beta Testing**
- **Google Play** - Internal testing track
- **TestFlight** - iOS beta distribution
- **Firebase App Distribution** - Cross-platform beta testing

## 🚀 Fastlane Automation

Fastlane automates the release process:

### **Android Deployment**
```bash
cd android

# Deploy to Play Store internal testing
bundle exec fastlane deploy_internal

# Deploy to Play Store production
bundle exec fastlane deploy_production
```

### **iOS Deployment**
```bash
cd ios

# Deploy to TestFlight
bundle exec fastlane beta

# Deploy to App Store
bundle exec fastlane release
```

### **Cross-platform Release**
```bash
# Build and deploy both platforms
./scripts/release-all-platforms.sh  # If available
```

## 📊 Release Workflow

### **Complete Release Process**
1. **Prepare release**
   ```bash
   # Update version
   # Edit pubspec.yaml: version: 1.2.0+10
   
   # Run quality checks
   flutter test
   flutter analyze
   ```

2. **Build release artifacts**
   ```bash
   # Android
   flutter build appbundle --release
   
   # iOS  
   flutter build ipa --release
   ```

3. **Deploy to stores**
   ```bash
   # Manual upload or use Fastlane
   cd android && bundle exec fastlane deploy_production
   cd ios && bundle exec fastlane release
   ```

4. **Post-release**
   - Monitor crash reports
   - Check user reviews
   - Plan next release

## 🔄 Version Management

### **Semantic Versioning**
```yaml
# pubspec.yaml
version: 1.2.3+45
#        |||||  |
#        ||||└─ Build number (auto-increment)
#        ||└─── Patch (bug fixes)
#        |└──── Minor (new features)  
#        └───── Major (breaking changes)
```

### **Automated Versioning**
```bash
# Build scripts can auto-increment versions
./scripts/build-release-local.sh  # Auto-generates version
```

## 🛡️ Security for Release

### **Production Security Checklist**
- [ ] **API keys secured** - No hardcoded secrets
- [ ] **Network security** - HTTPS everywhere
- [ ] **Data encryption** - Sensitive data encrypted
- [ ] **Authentication** - Secure login if applicable
- [ ] **Permissions** - Minimal required permissions

### **Store Requirements**
- [ ] **Privacy policy** - Required by both stores
- [ ] **Content rating** - Age-appropriate rating
- [ ] **Target SDK** - Latest Android target SDK
- [ ] **64-bit support** - Required for Play Store

## 🐛 Troubleshooting Deployment

### **Common Build Issues**
```bash
# Clean build environment
flutter clean
flutter pub get
flutter build appbundle --release

# Check signing
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

### **Store Rejection Issues**
- **Missing privacy policy** - Add privacy policy URL
- **Incorrect permissions** - Review app permissions
- **Content issues** - Follow store guidelines
- **Technical issues** - Fix crashes and bugs

### **Fastlane Issues**
```bash
# Update Fastlane
bundle update fastlane

# Check Fastlane configuration
bundle exec fastlane android validate
```

## 📈 Post-Deployment

### **Monitor Release**
- **Crash reporting** - Firebase Crashlytics, Sentry
- **Analytics** - User behavior tracking
- **Performance** - App performance monitoring
- **Reviews** - Store review monitoring

### **Continuous Deployment**
- **Automated releases** - CI/CD pipeline triggered releases
- **Feature flags** - Gradual feature rollouts
- **A/B testing** - Test different app versions
- **Hotfix deployment** - Quick critical bug fixes

## ➡️ Advanced Deployment

- **[Fastlane Complete Guide](FASTLANE.md)** - Detailed Fastlane setup
- **[CI/CD Deployment](../ci-cd/README.md)** - Automated deployment pipeline
- **[Release Management](RELEASE_MANAGEMENT.md)** - Advanced release strategies

*Deployment is the finish line - make sure your app reaches users successfully!*
