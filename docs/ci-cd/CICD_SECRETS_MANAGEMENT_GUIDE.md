# GitHub Actions Secrets Configuration Guide

## 🔍 Understanding "Context access might be invalid" Warnings

The lint warnings about "Context access might be invalid" for secrets like `ANDROID_KEYSTORE_BASE64`, `ANDROID_STORE_PASSWORD`, etc., are **normal and expected** when the secrets haven't been configured in the repository yet.

### ✅ These are NOT errors - they are warnings that indicate:
- The secret names are syntactically correct
- The secrets just haven't been added to the repository settings yet
- The workflow will still run, but will skip steps that require missing secrets

## 🔐 Required Secrets for Full Functionality

### Android Deployment Secrets
```
ANDROID_KEYSTORE_BASE64     # Base64 encoded keystore file
ANDROID_STORE_PASSWORD      # Keystore password
ANDROID_KEY_PASSWORD        # Key password  
ANDROID_KEY_ALIAS          # Key alias
GOOGLE_PLAY_JSON_KEY       # Google Play service account JSON
```

### iOS Deployment Secrets
```
APPLE_ID                             # Apple Developer Account email
APPLE_TEAM_ID                       # Apple Team ID
MATCH_PASSWORD                      # Match certificates password
MATCH_GIT_URL                       # Match certificates repository URL
MATCH_GIT_BASIC_AUTHORIZATION       # Git access token for certificates repo
APP_STORE_CONNECT_API_KEY_ID        # App Store Connect API Key ID
APP_STORE_CONNECT_API_ISSUER_ID     # App Store Connect API Issuer ID
APP_STORE_CONNECT_API_KEY_CONTENT   # App Store Connect API Key content
```

### Firebase Deployment Secrets
```
FIREBASE_APP_ID_ANDROID    # Firebase Android App ID
FIREBASE_APP_ID_IOS       # Firebase iOS App ID  
FIREBASE_TOKEN            # Firebase CI token
```

### Optional Notification Secrets
```
SLACK_WEBHOOK_URL         # Slack webhook for deployment notifications
```

## 🛠️ How to Add Secrets

### In GitHub Repository:
1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the exact name and value

### For Local Testing:
Create a `.env` file (add to `.gitignore`):
```bash
# Android Secrets
ANDROID_KEYSTORE_BASE64=<base64_encoded_keystore>
ANDROID_STORE_PASSWORD=<your_keystore_password>
ANDROID_KEY_PASSWORD=<your_key_password>
ANDROID_KEY_ALIAS=<your_key_alias>

# Add other secrets as needed...
```

## 🎯 Workflow Behavior Without Secrets

The workflow is designed to be **gracefully degrading**:

### ✅ **With Secrets**: Full deployment capabilities
- Complete signing and deployment to app stores
- Firebase distribution
- Full validation

### ⚠️ **Without Secrets**: Limited but functional
- Basic builds and testing
- Local development support
- Clear error messages about missing configuration

### 📋 **Example Output When Secrets Are Missing**:
```
⚠️ Some Android signing secrets are missing:
  - ANDROID_KEYSTORE_BASE64 not set
  - ANDROID_STORE_PASSWORD not set
ℹ️ Using existing key.properties file (if available)
```

## 🚀 Quick Setup Commands

### Generate Android Keystore Base64:
```bash
# Encode existing keystore
base64 -w 0 android/keystore.jks

# Or use our script
./scripts/create-keystore.sh
```

### Get Firebase Token:
```bash
firebase login:ci
```

### Validate Configuration:
```bash
# Test Android validation
cd android && fastlane validate

# Test iOS validation (requires secrets)
cd ios && fastlane validate
```

## ✅ Summary

- **Warnings are normal** when secrets aren't configured yet
- **Workflow will still run** with limited functionality
- **Add secrets gradually** as you set up each deployment target
- **All syntax is correct** - no errors in the workflow file

The workflow is **production-ready** and will work perfectly once you add the required secrets for your specific deployment needs!
