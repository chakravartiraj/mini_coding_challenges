# 🔐 Android Signing Guide

> **Everything you need to sign Android apps for release**

## 🎯 What This Does

Android apps need digital signatures to install on devices and publish to Google Play. This guide shows you how to:
- Create a keystore (your digital signature)
- Configure your app to use it
- Build signed apps ready for release

## 🔧 Quick Setup

### **1. Create Your Keystore (2 minutes)**

```bash
# Create directory for keystores
mkdir -p ~/keystores
cd ~/keystores

# Create keystore (replace with your details)
keytool -genkey -v \
  -keystore your-app-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias your-app \
  -storepass 'YourSecurePassword123!' \
  -keypass 'YourSecurePassword123!' \
  -dname "CN=Your Name, OU=Development, O=Your Company, L=Your City, ST=Your State, C=US"
```

**Important:** Use single quotes around passwords to handle special characters.

### **2. Configure Your App (1 minute)**

Create `android/key.properties`:
```properties
storePassword=YourSecurePassword123!
keyPassword=YourSecurePassword123!
keyAlias=your-app
storeFile=/home/yourusername/keystores/your-app-keystore.jks
```

**Update `android/app/build.gradle`:**
```gradle
// Add before android block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ... other release config ...
        }
    }
}
```

### **3. Build Signed App**

```bash
# Build signed APK
flutter build apk --release

# Or build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

**Files created:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

## ✅ Verify Signing

### **Check Your Keystore**
```bash
keytool -list -v -keystore ~/keystores/your-app-keystore.jks
```

### **Check Signed APK**
```bash
# Check APK signature
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Verify APK
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

### **Check App Bundle**
```bash
# Install bundletool if needed
# Download from: https://github.com/google/bundletool/releases

# Check bundle
java -jar bundletool.jar verify --bundle=build/app/outputs/bundle/release/app-release.aab
```

## 🔒 Security Best Practices

### **Protect Your Keystore**
- **Backup safely** - Keep multiple copies in secure locations
- **Never commit** `key.properties` to version control
- **Use strong passwords** - Mix letters, numbers, symbols
- **Limit access** - Only trusted team members need keystore access

### **Add to .gitignore**
```gitignore
# Android signing
android/key.properties
android/app/upload-keystore.jks
*.keystore
*.jks
```

## 🛠️ Common Problems

### **Password with Special Characters**
```bash
# ❌ This fails
keytool ... -storepass "Password!123"

# ✅ Use single quotes
keytool ... -storepass 'Password!123'
```

### **"keystore not found" Error**
```bash
# Check file exists
ls -la ~/keystores/your-app-keystore.jks

# Check path in key.properties matches exactly
```

### **Build Still Not Signed**
```bash
# Check build.gradle syntax
./gradlew app:dependencies

# Verify key.properties is loaded
# Add debug print in build.gradle:
println "Keystore path: ${keystoreProperties['storeFile']}"
```

### **Wrong SHA Fingerprint**
```bash
# Your keystore fingerprint
keytool -list -v -keystore ~/keystores/your-app-keystore.jks

# APK fingerprint (should match)
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

## 🎯 Quick Commands

```bash
# Create keystore
./scripts/create-keystore.sh  # If available

# Build release
flutter build apk --release
flutter build appbundle --release

# Verify signing
./scripts/verify-signing.sh   # If available
```

## ➡️ Next Steps

- **[Release Build Guide](RELEASE_BUILD_GUIDE.md)** - Complete release process
- **[Deployment Guide](../deployment/DEPLOYMENT_OVERVIEW_GUIDE.md)** - Upload to Play Store
- **[Build Scripts](../BUILD_SCRIPT_USAGE.md)** - Automate the process

*Remember: Treat your keystore like a house key - keep it safe and don't lose it!*
