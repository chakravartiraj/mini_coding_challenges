# 🔨 Build Overview

> **How to build the Mini Coding Challenges app**

## 🎯 Two Types of Builds

### **Debug Builds** 
- For development and testing
- Fast compilation
- Includes debugging info
- Uses debug keystore (auto-generated)

### **Release Builds**
- For production and app stores  
- Optimized and smaller
- Requires your own keystore
- Ready for distribution

## 🚀 Quick Commands

### **Debug Build**
```bash
# Build and run
flutter run

# Build APK only  
flutter build apk --debug

# Use build script (if available)
./scripts/build-debug-local.sh
```

### **Release Build**
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release

# Use build script (if available)  
./scripts/build-release-local.sh
```

## 📖 Detailed Guides

- **[Debug Builds](DEBUG.md)** - Development builds with automatic versioning
- **[Release Builds](RELEASE.md)** - Production builds for app stores
- **[Android Signing](ANDROID_SIGNING.md)** - Set up keystore for release builds

## 🛠️ Build Tools Available

### **Local Scripts**
- `./scripts/build-debug-local.sh` - Automated debug builds
- `./scripts/build-release-local.sh` - Automated release builds

### **Fastlane Integration**
```bash
cd android
bundle exec fastlane build_debug_artifacts
bundle exec fastlane build_release_artifacts
```

### **Shell Functions** (if configured)
```bash
build-debug          # Quick debug build
build-release         # Quick release build
```

See **[Build Script Usage](../BUILD_SCRIPT_USAGE.md)** for detailed usage.

## 🔍 Verify Your Builds

### **Debug Build**
```bash
# Check APK exists
ls -la build/app/outputs/flutter-apk/app-debug.apk

# Install on device
flutter install
```

### **Release Build**
```bash
# Check signing
jarsigner -verify build/app/outputs/flutter-apk/app-release.apk

# Check size (should be smaller than debug)
ls -lh build/app/outputs/flutter-apk/
```

## 🛡️ Before Release

**Required for release builds:**
1. **[Set up Android signing](ANDROID_SIGNING.md)** - Create keystore
2. **Run tests** - `flutter test`
3. **Check code quality** - `flutter analyze`
4. **Test on devices** - Install and verify functionality

## ➡️ Common Workflows

### **Daily Development**
1. `flutter run` - Test changes quickly
2. `flutter test` - Verify nothing broke
3. Repeat

### **Preparing Release**
1. [Set up signing](ANDROID_SIGNING.md)
2. [Build release](RELEASE.md)
3. [Deploy](../deployment/DEPLOYMENT_OVERVIEW_GUIDE.md)

*Choose your build type based on what you're doing - debug for development, release for distribution.*
