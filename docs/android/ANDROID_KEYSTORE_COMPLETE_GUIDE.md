# 🔐 Complete Android Keystore & Signing Guide

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Interactive Keystore Creation](#interactive-keystore-creation)
- [Manual Setup Process](#manual-setup-process)
- [Project Configuration](#project-configuration)
- [Building & Verification](#building--verification)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Overview

This guide provides a complete workflow for creating, configuring, and using Android keystores for signing Flutter applications in the Mini Coding Challenges project.

### What You'll Learn
- How to create secure Android keystores using interactive scripts
- How to configure Flutter projects for release signing
- How to build and verify signed APKs and App Bundles
- Security best practices for keystore management
- Troubleshooting common signing issues

## Prerequisites

### Required Tools
```bash
# Check if Java/keytool is installed
keytool -help

# Check Flutter installation
flutter doctor

# Verify Android toolchain
flutter doctor --android-licenses
```

### Expected Output
```
✅ Java JDK (for keytool)
✅ Flutter SDK
✅ Android SDK
✅ Android toolchain - develop for Android devices
```

## Interactive Keystore Creation

### 🚀 Quick Start (Recommended)

The easiest way to create a keystore is using our interactive script:

```bash
# Navigate to project root
cd /path/to/mini_coding_challenges

# Run interactive keystore creation
./scripts/create-keystore.sh
```

### Script Features
- ✅ **Input validation** with user-friendly prompts
- ✅ **Password strength checking** with security recommendations
- ✅ **Automatic directory setup** (creates ~/keystores/)
- ✅ **Keystore verification** after creation
- ✅ **Template generation** for key.properties
- ✅ **Project integration** (if run from Flutter project)
- ✅ **Security guidance** and next steps

### Example Interactive Session
```
🔐 Interactive Android Keystore Creation Script
=================================================

🔍 Checking prerequisites...
✅ keytool found
📁 Creating keystores directory: /home/user/keystores

Please provide the following information:

Project name (e.g., 'My Awesome App'): Mini Coding Challenges
Keystore filename [mini-coding-challenges-keystore.jks]: 
Key alias [mini-coding-challenges]: 

Organization Information:
Organization/Company name [Mini Coding Challenges Development]: 
Organizational Unit [Development Team]: 
City [Development City]: 
State/Province [Development State]: 
Country code (2 letters, e.g., US, UK, IN) [US]: 

Password Configuration:
Note: Use strong passwords with uppercase, numbers, and special characters
Keystore password (min 8 chars): [hidden]
Confirm password: [hidden]
✅ Passwords match

Do you want to use the same password for the key? [Y/n]: Y
✅ Using same password for key
```

## Manual Setup Process

### Step 1: Create Keystores Directory
```bash
mkdir -p ~/keystores
cd ~/keystores
```

### Step 2: Generate Keystore
```bash
keytool -genkey -v \
  -keystore your-app-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias your-app-key
```

### Step 3: Verify Keystore
```bash
keytool -list -v \
  -keystore your-app-keystore.jks \
  -alias your-app-key
```

## Project Configuration

### Step 1: Create key.properties
Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_app_key
storeFile=/home/user/keystores/your-app-keystore.jks
```

### Step 2: Update build.gradle.kts
In `android/app/build.gradle.kts`:

```kotlin
import java.io.FileInputStream
import java.util.Properties

// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing configuration ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

### Step 3: Secure Your Files
Add to `.gitignore`:
```gitignore
# Android signing
android/key.properties
*.jks
*.keystore

# Keystores directory
keystores/
```

## Building & Verification

### Build Signed APK
```bash
flutter build apk --release
```

### Build Signed App Bundle
```bash
flutter build appbundle --release
```

### Verify Builds with Script
```bash
./scripts/verify-builds.sh
```

### Manual Verification
```bash
# Check APK signature
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Check App Bundle signature
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab

# Compare with keystore
keytool -list -v -keystore ~/keystores/your-keystore.jks -alias your-alias
```

## Security Best Practices

### 🔐 Keystore Security
- **Never commit keystores** to version control
- **Use strong passwords** (8+ chars, mixed case, numbers, symbols)
- **Store passwords securely** (password manager recommended)
- **Backup keystores safely** (encrypted, multiple locations)
- **Limit access** to keystores and passwords

### 🛡️ Project Security
- **Add .gitignore rules** for sensitive files
- **Use environment variables** for CI/CD
- **Separate keystores** for different environments
- **Regular password rotation** for production keystores

### 📁 Recommended Structure
```
~/keystores/                    # Secure keystore directory
├── company-prod-keystore.jks   # Production keystore
├── company-dev-keystore.jks    # Development keystore
└── key.properties.template     # Template for projects
```

## Troubleshooting

### Common Issues

#### 1. "keytool: command not found"
**Solution:**
```bash
# Install Java JDK
sudo apt install default-jdk  # Ubuntu/Debian
brew install openjdk          # macOS

# Or install Android Studio (includes Java)
```

#### 2. "Keystore was tampered with, or password was incorrect"
**Solutions:**
- Verify password is correct
- Check keystore file integrity
- Ensure correct keystore path in key.properties

#### 3. "Certificate fingerprints don't match"
**Solutions:**
- Verify same keystore is used for all builds
- Check keystore alias matches
- Regenerate if using wrong keystore

#### 4. Build fails with signing errors
**Solutions:**
- Verify key.properties exists and is correct
- Check file paths are absolute
- Ensure keystore file permissions are correct

### Debug Commands
```bash
# Check keystore details
keytool -list -v -keystore path/to/keystore.jks

# Verify APK signature
keytool -printcert -jarfile app-release.apk

# Check build configuration
flutter build apk --release --verbose
```

## Advanced Usage

### Multiple Keystores
For different environments or apps:

```bash
# Create development keystore
./scripts/create-keystore.sh
# Name: myapp-dev-keystore.jks
# Alias: myapp-dev

# Create production keystore
./scripts/create-keystore.sh
# Name: myapp-prod-keystore.jks
# Alias: myapp-prod
```

### Environment-Specific Builds
```bash
# Development build
cp android/key.dev.properties android/key.properties
flutter build apk --release

# Production build
cp android/key.prod.properties android/key.properties
flutter build appbundle --release
```

### CI/CD Integration
```yaml
# Example GitHub Actions
- name: Setup signing
  run: |
    echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/keystore.jks
    echo "storeFile=../keystore.jks" > android/key.properties
    echo "storePassword=${{ secrets.STORE_PASSWORD }}" >> android/key.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
    echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
```

### Keystore Information Export
```bash
# Export certificate for Play Store
keytool -export -rfc \
  -keystore your-keystore.jks \
  -alias your-alias \
  -file upload_certificate.pem
```

## Quick Reference

### Essential Commands
```bash
# Create keystore (interactive)
./scripts/create-keystore.sh

# Build signed APK
flutter build apk --release

# Build signed App Bundle
flutter build appbundle --release

# Verify builds
./scripts/verify-builds.sh

# Check keystore
keytool -list -v -keystore ~/keystores/your-keystore.jks
```

### File Locations
```
~/keystores/                    # Keystores directory
android/key.properties          # Signing configuration
android/app/build.gradle.kts    # Build configuration
build/app/outputs/              # Built APKs and bundles
scripts/create-keystore.sh      # Interactive creation script
scripts/verify-builds.sh        # Verification script
```

---

## 📚 Additional Resources

- [ANDROID_KEYSTORE_GUIDE.md](ANDROID_KEYSTORE_GUIDE.md) - Basic keystore concepts
- [ANDROID_SIGNING_SETUP.md](ANDROID_SIGNING_SETUP.md) - Step-by-step setup
- [ANDROID_SIGNING_SUCCESS.md](ANDROID_SIGNING_SUCCESS.md) - Success verification
- [Flutter Documentation](https://docs.flutter.dev/deployment/android#signing-the-app)
- [Android Developer Guide](https://developer.android.com/studio/publish/app-signing)

## 🆘 Need Help?

1. **Check the troubleshooting section** above
2. **Run verification script**: `./scripts/verify-builds.sh`
3. **Review build logs** with `flutter build apk --verbose`
4. **Check our documentation** in the `docs/setup/` directory

---

*This guide is part of the Mini Coding Challenges Flutter project documentation.*
