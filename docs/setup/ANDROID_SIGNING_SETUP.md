# 🔐 Mini Coding Challenges - Android Keystore Configuration

## ✅ Configuration Complete!

Your Flutter project has been successfully configured for Android app signing with a reusable keystore.

---

## 📁 **Files Configured**

### 1. `android/key.properties` ✅
```properties
storePassword=your_keystore_password_here
keyPassword=your_key_password_here  
keyAlias=your_key_alias_here
storeFile=/home/io/keystores/your-keystore-name.jks
```

**📝 Action Required**: Update this file with your actual keystore details:
- Replace `your_keystore_password_here` with your keystore password
- Replace `your_key_password_here` with your key password
- Replace `your_key_alias_here` with your key alias
- Replace `your-keystore-name.jks` with your actual keystore filename

### 2. `android/app/build.gradle.kts` ✅
- Added keystore properties loading
- Configured release signing config
- Set up proper signing for release builds

### 3. `.gitignore` ✅
- Added security entries to prevent committing sensitive files
- Protected keystore and key.properties from version control

---

## 🔧 **How to Use Your Keystore**

### Step 1: Update key.properties
Edit `android/key.properties` with your actual values:
```properties
storePassword=YourActualKeystorePassword
keyPassword=YourActualKeyPassword
keyAlias=YourActualAlias
storeFile=/home/io/keystores/your-actual-keystore.jks
```

### Step 2: Test the Configuration
```bash
# Build signed release APK
flutter build apk --release

# Build signed App Bundle (for Play Store)
flutter build appbundle --release
```

### Step 3: Verify Signing
```bash
# Check if APK is properly signed
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Check App Bundle signing
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

---

## 🔄 **Reusing Keystore for Future Projects**

Since you've created a master keystore, here's how to use it for new projects:

### For Each New Flutter Project:
1. **Copy key.properties template**:
   ```bash
   cp ~/keystores/key.properties.template new-project/android/key.properties
   ```

2. **Update the alias in key.properties**:
   ```properties
   keyAlias=new-project-alias
   # Keep same storeFile, storePassword, keyPassword
   ```

3. **Add new alias to existing keystore**:
   ```bash
   keytool -genkey -v -keystore ~/keystores/master-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias new-project-alias
   ```

4. **Copy build.gradle.kts configuration** from this project

---

## 🚀 **Build Commands**

### Development Builds
```bash
# Debug build (uses debug keystore)
flutter build apk --debug
flutter run
```

### Release Builds
```bash
# Release APK (uses your keystore)
flutter build apk --release

# Release App Bundle for Play Store
flutter build appbundle --release

# Optimized release with obfuscation
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

---

## 🔍 **Troubleshooting**

### Common Issues:

#### 1. "Keystore file does not exist"
- Verify the `storeFile` path in `key.properties`
- Ensure the keystore file exists at that location

#### 2. "Cannot recover key"
- Check that `keyAlias` matches an alias in your keystore
- Verify `keyPassword` is correct

#### 3. "Keystore was tampered with"
- Verify `storePassword` is correct
- Ensure keystore file isn't corrupted

### Debug Commands:
```bash
# List all aliases in keystore
keytool -list -keystore ~/keystores/your-keystore.jks

# Verify keystore details
keytool -list -v -keystore ~/keystores/your-keystore.jks -alias your-alias
```

---

## 🔒 **Security Checklist**

- [ ] Keystore stored outside project directory (`~/keystores/`)
- [ ] `key.properties` added to `.gitignore`
- [ ] Keystore backed up securely
- [ ] Strong passwords used
- [ ] Passwords stored in secure password manager
- [ ] Never share keystore or passwords publicly

---

## 📱 **Next Steps**

### For Play Store Release:
1. **Update app details** in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1
   ```

2. **Update application ID** in `build.gradle.kts`:
   ```kotlin
   applicationId = "com.yourcompany.mini_coding_challenges"
   ```

3. **Test release build**:
   ```bash
   flutter build appbundle --release
   ```

4. **Upload to Play Console** and test internal distribution

### For Continuous Integration:
- Set up GitHub Actions with encrypted keystore
- Use GitHub Secrets for passwords
- Automate release builds

---

**🎉 Your Android signing is now configured and ready for production releases!**

*Remember: Keep your keystore and passwords secure - losing them means you can't update your app on Play Store.*
