# 🛠️ Interactive Scripts Guide

## Overview

This directory contains interactive scripts designed to guide developers through Android keystore creation, verification, and learning processes. All scripts are designed with user-friendly interfaces, comprehensive error handling, and educational value.

## Available Scripts

### 1. 🔐 `create-keystore.sh` - Interactive Keystore Creation

**Purpose:** Create Android keystores with guided prompts and validation.

**Features:**
- ✅ Interactive prompts with input validation
- ✅ Password strength checking
- ✅ Automatic directory setup
- ✅ Keystore verification after creation
- ✅ Template generation for Flutter projects
- ✅ Security guidance and best practices

**Usage:**
```bash
./scripts/create-keystore.sh
```

**What it does:**
1. Checks prerequisites (Java/keytool availability)
2. Creates `~/keystores/` directory if needed
3. Prompts for project information (name, organization, etc.)
4. Collects secure passwords with confirmation
5. Generates the keystore using keytool
6. Verifies the created keystore
7. Creates `key.properties` template
8. Provides next steps and security guidance

**Example Session:**
```
🔐 Interactive Android Keystore Creation Script
=================================================

Project name: Mini Coding Challenges
Keystore filename [mini-coding-challenges-keystore.jks]: 
Key alias [mini-coding-challenges]: 
Organization: Your Company
City: Your City
...
✅ Keystore created successfully!
```

---

### 2. 🔍 `verify-builds.sh` - Build Verification

**Purpose:** Verify signed APKs and App Bundles against keystores.

**Features:**
- ✅ Checks APK and App Bundle existence
- ✅ Displays file sizes and paths
- ✅ Extracts and compares certificate fingerprints
- ✅ Verifies signatures match keystore
- ✅ Provides quick build commands

**Usage:**
```bash
./scripts/verify-builds.sh
```

**What it checks:**
1. Keystore file existence and details
2. APK file existence and signature
3. App Bundle file existence and signature
4. SHA256 fingerprint comparison
5. Overall verification status

**Example Output:**
```
🔍 Mini Coding Challenges - Build Verification Script
==================================================

🔑 Keystore Information:
✅ Keystore exists: 2.1K /home/user/keystores/krupto-keystore.jks

📱 Checking Release APK...
✅ APK exists: 18M build/app/outputs/flutter-apk/app-release.apk
✅ APK signature matches keystore!

📦 Checking Release App Bundle...
✅ Bundle exists: 17M build/app/outputs/bundle/release/app-release.aab
✅ Bundle signature matches keystore!
```

---

### 3. 🎓 `keystore-training.sh` - Interactive CLI Training

**Purpose:** Hands-on training for keystore management commands.

**Features:**
- ✅ Interactive command-line training
- ✅ Step-by-step lessons with explanations
- ✅ Command validation and feedback
- ✅ Multiple training modes
- ✅ Safe training environment
- ✅ Comprehensive cleanup

**Usage:**
```bash
./scripts/keystore-training.sh
```

**Training Modes:**
1. **Full Training** - Complete 8-lesson course
2. **Quick Review** - Essential commands reference
3. **Custom Lesson** - Choose specific topics
4. **Exit** - End training session

**Lessons Covered:**
1. Setting Up Training Environment
2. Checking Prerequisites
3. Creating Your First Keystore
4. Inspecting Keystore Contents
5. Certificate Fingerprinting
6. Keystore Backup and Security
7. Managing Multiple Aliases
8. Cleanup and Summary

**Learning Objectives:**
- Master keytool command-line usage
- Understand certificate concepts
- Learn security best practices
- Practice real-world scenarios

---

### 4. 📊 `test_coverage_report.sh` - Test Coverage Analysis

**Purpose:** Generate comprehensive test coverage reports.

**Features:**
- ✅ Runs all tests with coverage
- ✅ Generates HTML and LCOV reports
- ✅ Opens reports in browser
- ✅ Provides coverage summaries

**Usage:**
```bash
./scripts/test_coverage_report.sh
```

---

### 5. 🐙 `setup_github.sh` - GitHub Repository Setup

**Purpose:** Initialize and configure GitHub repositories.

**Features:**
- ✅ Git repository initialization
- ✅ GitHub remote configuration
- ✅ Branch setup and protection
- ✅ Initial commit automation

**Usage:**
```bash
./scripts/setup_github.sh
```

## Script Integration Workflow

### Complete Development Workflow

```bash
# 1. Create keystore for signing
./scripts/create-keystore.sh

# 2. Build signed applications
flutter build apk --release
flutter build appbundle --release

# 3. Verify builds and signatures
./scripts/verify-builds.sh

# 4. Run tests and generate coverage
./scripts/test_coverage_report.sh

# 5. Commit and push to GitHub
git add .
git commit -m "Add signed builds"
git push origin main
```

### Training Workflow for New Developers

```bash
# 1. Learn keystore basics
./scripts/keystore-training.sh

# 2. Practice with real keystore creation
./scripts/create-keystore.sh

# 3. Build and verify applications
flutter build apk --release
./scripts/verify-builds.sh

# 4. Set up project repository
./scripts/setup_github.sh
```

## Prerequisites

### System Requirements
- **Operating System:** Linux, macOS, or Windows with bash
- **Java JDK:** Required for keytool (included with Android Studio)
- **Flutter SDK:** For building applications
- **Git:** For repository management

### Verification Commands
```bash
# Check Java/keytool
keytool -help

# Check Flutter
flutter doctor

# Check Git
git --version

# Check script permissions
ls -la scripts/
```

## Troubleshooting

### Common Issues

#### 1. Permission Denied
```bash
# Fix script permissions
chmod +x scripts/*.sh
```

#### 2. keytool Command Not Found
```bash
# Install Java JDK
sudo apt install default-jdk  # Ubuntu/Debian
brew install openjdk          # macOS

# Or install Android Studio
```

#### 3. Flutter Build Fails
```bash
# Check Flutter setup
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

#### 4. Git Configuration Issues
```bash
# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Debug Mode

Most scripts support verbose output:
```bash
# Run with bash debug mode
bash -x scripts/create-keystore.sh

# Check script syntax
bash -n scripts/create-keystore.sh
```

## Security Considerations

### Script Security
- ✅ Scripts use `set -e` for error handling
- ✅ Input validation prevents injection attacks
- ✅ Passwords are handled securely (not logged)
- ✅ File permissions are set restrictively
- ✅ Temporary files are cleaned up

### Keystore Security
- ✅ Keystores stored in `~/keystores/` (outside project)
- ✅ Strong password requirements enforced
- ✅ Secure file permissions (600) applied
- ✅ Backup procedures explained
- ✅ .gitignore rules prevent accidental commits

### Best Practices
1. **Never commit keystores** to version control
2. **Use strong, unique passwords** for each keystore
3. **Backup keystores securely** in multiple locations
4. **Rotate passwords regularly** for production keystores
5. **Limit access** to keystore files and passwords
6. **Monitor keystore usage** in production environments

## Customization

### Environment Variables

Scripts respect these environment variables:
```bash
# Custom keystore directory
export KEYSTORE_DIR="$HOME/my-keystores"

# Default keystore settings
export DEFAULT_KEYSTORE_VALIDITY="7300"  # 20 years
export DEFAULT_KEY_SIZE="4096"           # 4096-bit keys
export DEFAULT_KEY_ALGORITHM="RSA"       # RSA algorithm
```

### Script Modifications

To customize scripts for your organization:

1. **Update default values** in script headers
2. **Modify validation rules** for passwords/inputs
3. **Change directory structures** as needed
4. **Add organization-specific checks**
5. **Integrate with existing CI/CD pipelines**

### Example Customization
```bash
# In create-keystore.sh, modify defaults:
DEFAULT_VALIDITY="25550"     # 70 years
DEFAULT_ORGANIZATION="YourCompany"
DEFAULT_COUNTRY="US"
```

## Script Maintenance

### Regular Updates
- Review and update security practices
- Test scripts with new Flutter/Android versions
- Update documentation as needed
- Add new features based on user feedback

### Version Control
- All scripts are tracked in Git
- Changes are documented in commit messages
- Breaking changes are noted in documentation
- Backward compatibility is maintained when possible

## Integration with CI/CD

### GitHub Actions Example
```yaml
name: Build and Sign APK

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup signing
      env:
        KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
        STORE_PASSWORD: ${{ secrets.STORE_PASSWORD }}
        KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
        KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
      run: |
        echo "$KEYSTORE_BASE64" | base64 -d > android/keystore.jks
        echo "storeFile=../keystore.jks" > android/key.properties
        echo "storePassword=$STORE_PASSWORD" >> android/key.properties
        echo "keyPassword=$KEY_PASSWORD" >> android/key.properties
        echo "keyAlias=$KEY_ALIAS" >> android/key.properties
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Verify build
      run: ./scripts/verify-builds.sh
```

## Support and Documentation

### Additional Resources
- [Complete Keystore Guide](../docs/setup/ANDROID_KEYSTORE_COMPLETE_GUIDE.md)
- [Flutter Documentation](https://docs.flutter.dev/deployment/android)
- [Android Developer Guide](https://developer.android.com/studio/publish/app-signing)
- [CLI Training Materials](../docs/training/)

### Getting Help
1. Check script output for specific error messages
2. Review the troubleshooting section above
3. Run verification commands to diagnose issues
4. Consult the complete documentation guides
5. Test with the training script to verify understanding

---

*These scripts are part of the Mini Coding Challenges Flutter project and are designed to streamline the development workflow while maintaining security best practices.*
