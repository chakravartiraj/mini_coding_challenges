# 🔐 Step-by-Step Guide: Adding GitHub Secrets for Deployment

Here's a complete walkthrough to add all the secrets used in your `fastlane-deployment.yml` workflow:

## 📍 **Step 1: Navigate to Repository Settings**

1. **Open your GitHub repository** in a web browser
   - Go to: `https://github.com/YOUR_USERNAME/mini_coding_challenges`

2. **Click the "Settings" tab**
   - Located at the top of the repository page (next to Insights)

3. **Scroll down to "Security" section in the left sidebar**
   - Look for "Secrets and variables"

4. **Click "Actions"**
   - This opens the GitHub Actions secrets management page

## 📍 **Step 2: Add Android Deployment Secrets**

### 🤖 **Android Keystore Secrets**

1. **Click "New repository secret"** (green button)

2. **Add each secret one by one:**

   **Secret 1: ANDROID_KEYSTORE_BASE64**
   - Name: `ANDROID_KEYSTORE_BASE64`
   - Value: Get this by running:
     ```bash
     cd /home/io/StudioProjects/mini_coding_challenges
     base64 -w 0 /home/io/keystores/krupto-keystore.jks
     ```
   - Copy the output (long base64 string) and paste as the value

   **Secret 2: ANDROID_STORE_PASSWORD**
   - Name: `ANDROID_STORE_PASSWORD`
   - Value: `ApoCryPhal!3` (your keystore password)

   **Secret 3: ANDROID_KEY_PASSWORD**
   - Name: `ANDROID_KEY_PASSWORD`
   - Value: `ApoCryPhal!3` (your key password)

   **Secret 4: ANDROID_KEY_ALIAS**
   - Name: `ANDROID_KEY_ALIAS`
   - Value: `krupto` (your key alias)

### 🏪 **Google Play Console Secret (Optional)**

5. **Add Google Play Service Account Key:**
   
   **Secret 5: GOOGLE_PLAY_JSON_KEY**
   - Name: `GOOGLE_PLAY_JSON_KEY`
   - Value: Your Google Play Console service account JSON content
   - To get this:
     1. Go to [Google Play Console](https://play.google.com/console)
     2. Select your app → Setup → API access
     3. Create/download service account JSON file
     4. Copy the entire JSON content and paste as the secret value

## 📍 **Step 3: Add Firebase Secrets (Optional)**

### 🔥 **Firebase App Distribution**

1. **Get Firebase Token:**
   ```bash
   # Install Firebase CLI if not already installed
   npm install -g firebase-tools
   
   # Login and get CI token
   firebase login:ci
   ```

2. **Add Firebase Secrets:**

   **Secret 6: FIREBASE_TOKEN**
   - Name: `FIREBASE_TOKEN`
   - Value: The token from the `firebase login:ci` command

   **Secret 7: FIREBASE_APP_ID_ANDROID**
   - Name: `FIREBASE_APP_ID_ANDROID`
   - Value: Your Firebase Android App ID (format: `1:123456789:android:abcdef123456`)
   - Find in Firebase Console → Project Settings → Your apps

   **Secret 8: FIREBASE_APP_ID_IOS** (if you have iOS)
   - Name: `FIREBASE_APP_ID_IOS`
   - Value: Your Firebase iOS App ID

## 📍 **Step 4: Add iOS Secrets (Optional - if deploying iOS)**

### 🍎 **Apple Developer Secrets**

**Secret 9: APPLE_ID**
- Name: `APPLE_ID`
- Value: Your Apple Developer account email

**Secret 10: APPLE_TEAM_ID**
- Name: `APPLE_TEAM_ID`
- Value: Your Apple Team ID (found in Apple Developer Portal)

### 🔐 **iOS Code Signing (Match)**

**Secret 11: MATCH_PASSWORD**
- Name: `MATCH_PASSWORD`
- Value: Password for your certificates repository

**Secret 12: MATCH_GIT_URL**
- Name: `MATCH_GIT_URL`
- Value: Git URL for your certificates repository

**Secret 13: MATCH_GIT_BASIC_AUTHORIZATION**
- Name: `MATCH_GIT_BASIC_AUTHORIZATION`
- Value: Base64 encoded `username:token` for git access

### 📱 **App Store Connect API**

**Secret 14-16: App Store Connect API Keys**
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY_CONTENT`

## 📍 **Step 5: Add Notification Secrets (Optional)**

### 💬 **Slack Notifications**

**Secret 17: SLACK_WEBHOOK_URL**
- Name: `SLACK_WEBHOOK_URL`
- Value: Your Slack webhook URL for deployment notifications

## 📍 **Step 6: Verify Your Secrets**

1. **Check the secrets list** in GitHub
   - You should see all the secrets you added listed (values are hidden)

2. **Test the workflow:**
   ```bash
   # Trigger a manual deployment to test
   # Go to Actions tab → "Mini Coding Challenges - Fastlane Deployment Pipeline"
   # Click "Run workflow" → Choose platform and track
   ```

## 🎯 **Quick Reference: Minimum Required Secrets**

### **For Android Only:**
```
✅ ANDROID_KEYSTORE_BASE64
✅ ANDROID_STORE_PASSWORD  
✅ ANDROID_KEY_PASSWORD
✅ ANDROID_KEY_ALIAS
```

### **For Firebase Distribution:**
```
✅ FIREBASE_TOKEN
✅ FIREBASE_APP_ID_ANDROID
```

### **For Google Play Store:**
```
✅ GOOGLE_PLAY_JSON_KEY
```

## 🔧 **Quick Commands to Get Secret Values:**

```bash
# Get keystore base64
cd /home/io/StudioProjects/mini_coding_challenges
base64 -w 0 /home/io/keystores/krupto-keystore.jks

# Get Firebase token
firebase login:ci

# Check current keystore details
cd android && cat key.properties
```

## ✅ **Final Verification**

Once you've added the secrets, your workflow will:
- ✅ **Stop showing "context access might be invalid" warnings**
- ✅ **Successfully sign and deploy your Android app**
- ✅ **Work with Firebase App Distribution**
- ✅ **Deploy to Google Play Store** (if configured)

**You're now ready for automated deployments!** 🚀

---

## 📋 **Troubleshooting**

### **Common Issues:**

1. **Secret name mismatch**: Ensure secret names match exactly (case-sensitive)
2. **Base64 encoding**: Use `base64 -w 0` to avoid line breaks
3. **JSON formatting**: Ensure Google Play JSON is valid and complete
4. **Firebase token expiry**: Regenerate token if deployments fail

### **Testing Individual Components:**

```bash
# Test Android signing locally
cd android && fastlane validate

# Test Firebase connection
firebase projects:list

# Test Google Play connection (requires service account)
# This will be tested through the workflow
```

### **Getting Help:**

- **GitHub Actions Logs**: Check the Actions tab for detailed error messages
- **Fastlane Documentation**: [docs.fastlane.tools](https://docs.fastlane.tools)
- **Firebase CLI Help**: `firebase --help`

---

*Created: June 17, 2025*  
*Project: Mini Coding Challenges*  
*Pipeline: GitHub Actions + Fastlane*
