# 🚀 Release Builds

> **Build production-ready apps for app stores and distribution**

## 🎯 What Are Release Builds?

Release builds are for production:
- **Optimized code** - Smaller size, better performance
- **No debug info** - Clean, production-ready
- **Requires signing** - Must use your own keystore
- **App store ready** - Can upload to Google Play, etc.

## ⚠️ Before You Start

**Required:**
1. **[Android keystore set up](ANDROID_SIGNING.md)** - Digital signature for your app
2. **Tests passing** - `flutter test`
3. **Code quality clean** - `flutter analyze`

## 🔨 Build Release APK

### **Quick Build**
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)  
flutter build appbundle --release
```

### **Using Build Scripts** (Recommended)
```bash
# Automated release build with versioning
./scripts/build-release-local.sh

# Or if shell functions are set up
build-release
```

## 📱 Release Build Types

### **APK (Android Package)**
- Direct install on devices
- Larger file size
- Good for testing and direct distribution

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### **App Bundle (Recommended)**  
- Optimized for Google Play Store
- Smaller downloads for users
- Dynamic delivery support

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

## 🔐 Signing Requirements

Release builds **must be signed** with your keystore:

1. **Create keystore** (one-time setup):
   ```bash
   # See Android Signing Guide for details
   keytool -genkey -v -keystore your-keystore.jks ...
   ```

2. **Configure signing** in `android/key.properties`:
   ```properties
   storePassword=YourPassword
   keyPassword=YourPassword  
   keyAlias=your-alias
   storeFile=/path/to/your-keystore.jks
   ```

3. **Update build.gradle** to use signing config

**Need help?** See **[Android Signing Guide](ANDROID_SIGNING.md)** for complete setup.

## ✅ Verify Release Build

### **Check Signing**
```bash
# Verify APK is signed
jarsigner -verify -verbose build/app/outputs/flutter-apk/app-release.apk

# Check signature details
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

### **Check Size** (should be smaller than debug)
```bash
# Compare sizes
ls -lh build/app/outputs/flutter-apk/
# app-debug.apk    ~50MB
# app-release.apk  ~25MB (approximately half)
```

### **Test Installation**
```bash
# Install on device for testing
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 🎁 Build Artifacts

After successful build:

### **Standard Flutter Output**
```
build/app/outputs/
├── flutter-apk/
│   ├── app-release.apk         # Main APK
│   └── app-release-arm64-v8a.apk  # Architecture-specific
└── bundle/release/
    └── app-release.aab         # App Bundle
```

### **Build Script Output** (if using scripts)
```
artifacts/release/
├── builds/2024-11-27_14-30-52/    # Timestamped builds
│   ├── app-release-1.0.0+timestamp.apk
│   ├── app-release-1.0.0+timestamp.aab
│   └── build-info.json
└── current/                        # Latest build symlink
```

## 🔄 Release Versioning

### **Manual Versioning**
Update `pubspec.yaml`:
```yaml
version: 1.2.3+45  # version+build_number
```

### **Automatic Versioning** (build scripts)
Automatically generates:
- Version based on git tags or timestamps
- Build numbers from commit count
- Timestamped artifacts

## 🚀 Release Workflows

### **Fastlane Integration**
```bash
cd android
bundle exec fastlane build_release_artifacts
```

### **Complete Release Process**
1. **Update version** in `pubspec.yaml`
2. **Run tests** - `flutter test`
3. **Check quality** - `flutter analyze`
4. **Build release** - `./scripts/build-release-local.sh`
5. **Test install** - Install APK on device
6. **Upload to store** - Use App Bundle for Play Store

## 🛠️ Troubleshooting

### **"Keystore not found"**
```bash
# Check keystore path in android/key.properties
ls -la /path/to/your-keystore.jks

# Verify path is absolute, not relative
```

### **"Wrong password"**
```bash
# Test keystore access
keytool -list -v -keystore /path/to/your-keystore.jks

# Check passwords match in key.properties
```

### **Build not signed**
```bash
# Check if key.properties is loaded in build.gradle
# Add debug print: println "Using keystore: ${keystoreProperties['storeFile']}"

# Verify signing config is applied to release build type
```

### **APK too large**
```bash
# Enable shrinking and obfuscation in build.gradle
android {
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt')
        }
    }
}
```

## 📊 Release Quality Checklist

Before distributing:
- [ ] **Tests pass** - `flutter test`
- [ ] **Analysis clean** - `flutter analyze`  
- [ ] **Properly signed** - Verify with jarsigner
- [ ] **Tested on device** - Install and run APK
- [ ] **Version updated** - Check pubspec.yaml
- [ ] **Performance tested** - Check app responsiveness

## ➡️ Next Steps

- **[Deployment Guide](../deployment/DEPLOYMENT_OVERVIEW_GUIDE.md)** - Upload to app stores
- **[Android Signing](ANDROID_SIGNING.md)** - Keystore setup help
- **[CI/CD Pipeline](../ci-cd/CICD_PIPELINE_OVERVIEW.md)** - Automate releases

*Release builds are what users see - make sure they're perfect!*
