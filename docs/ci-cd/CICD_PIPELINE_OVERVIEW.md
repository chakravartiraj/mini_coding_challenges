# 🚀 CI/CD Pipeline

> **Automated testing, building, and deployment for the Mini Coding Challenges app**

## 🎯 What This Does

The CI/CD pipeline automatically:
- **Tests your code** when you push changes
- **Checks code quality** (linting, formatting, security)
- **Builds apps** for different platforms
- **Deploys releases** when ready

## ⚡ Quick Start

### **1. Enable Pipeline (One-time setup)**

**Required secrets in GitHub:**
```
ANDROID_KEYSTORE_BASE64     # Your keystore file (encoded)
ANDROID_KEYSTORE_PASSWORD   # Keystore password
ANDROID_KEY_ALIAS          # Key alias name
ANDROID_KEY_PASSWORD       # Key password
```

### **2. How to Set Up Secrets**

1. **Encode your keystore:**
   ```bash
   base64 -w 0 ~/keystores/your-keystore.jks > keystore.base64
   ```

2. **Add to GitHub:**
   - Go to repository → Settings → Secrets and Variables → Actions
   - Click "New repository secret"
   - Add each secret above

**Need help?** See **[GitHub Secrets Setup](GITHUB_SECRETS_SETUP.md)**

### **3. Trigger Pipeline**

```bash
# Push to main branch
git add .
git commit -m "feat: add new feature"
git push origin main

# Or create pull request
# Pipeline runs automatically
```

## 🔄 What Happens When You Push

### **Quality Checks (2-3 minutes)**
1. **Code Analysis** - `flutter analyze` 
2. **Code Formatting** - `dart format --set-exit-if-changed`
3. **Linting** - Custom lint rules
4. **Security Scan** - Check for vulnerabilities

### **Testing (3-5 minutes)**
1. **Unit Tests** - `flutter test`
2. **Widget Tests** - UI component testing
3. **Integration Tests** - Full app flow testing

### **Building (5-10 minutes)**
1. **Debug APK** - Development version
2. **Release APK** - Production version (if secrets are set up)
3. **App Bundle** - Play Store optimized version

## 📁 Pipeline Outputs

After successful run, download artifacts:
- `debug-artifacts.zip` - Debug APK and metadata
- `release-artifacts.zip` - Release APK, Bundle, and metadata
- Build logs and test reports

## 🎮 Development Workflow

### **Daily Development**
```bash
# Work on feature
git checkout -b feature/pagination-improvement

# Make changes
# ...

# Push and create PR
git push origin feature/pagination-improvement
# Create pull request → Pipeline runs automatically
```

### **Release Process**
```bash
# Merge to main when PR approved
git checkout main
git merge feature/pagination-improvement
git push origin main

# Pipeline builds release artifacts automatically
# Download from GitHub Actions → Artifacts
```

## 🛠️ Local Pipeline Testing

Test pipeline steps locally before pushing:

```bash
# Quality checks
flutter analyze
dart format --set-exit-if-changed .
flutter test

# Local builds
./scripts/build-debug-local.sh
./scripts/build-release-local.sh  # If keystore is set up
```

## 📊 Pipeline Configuration

### **Triggers**
- **Push to main** - Full pipeline (quality + testing + building)
- **Pull requests** - Quality and testing only
- **Manual** - Can trigger from GitHub Actions tab

### **Parallel Jobs**
- Quality checks and testing run in parallel
- Building happens after tests pass
- Faster overall pipeline execution

### **Smart Caching**
- Flutter SDK cached between runs
- Dependencies cached
- Faster subsequent builds

## 🔧 Advanced Configuration

### **Custom Test Suites**
```yaml
# .github/workflows/ci.yml
strategy:
  matrix:
    test-suite: [unit, widget, integration]
```

### **Multiple Flutter Versions**
```yaml
strategy:
  matrix:
    flutter-version: [3.16.9, 3.19.0]
```

### **Platform-Specific Builds**
```yaml
strategy:
  matrix:
    platform: [android, ios, web]
```

## 🛡️ Security Features

- **Secret scanning** enabled
- **Dependency vulnerability** checks
- **Code quality** enforcement
- **Signed releases** only

## 📈 Monitoring & Debugging

### **Check Pipeline Status**
- GitHub repository → Actions tab
- See all runs and their status

### **Debug Failed Runs**
1. Click on failed run
2. Check specific job logs
3. Look for error messages
4. Fix issues and push again

### **Common Issues**
- **Tests failing** - Fix test code
- **Lint errors** - Run `dart format .`
- **Build errors** - Check dependencies
- **Missing secrets** - Verify GitHub secrets

## ➡️ Next Steps

- **[GitHub Actions Workflow](GITHUB_ACTIONS.md)** - Detailed workflow configuration
- **[Secrets Setup](SECRETS.md)** - Complete secrets guide  
- **[Quality Pipeline](QUALITY_FIRST_PIPELINE.md)** - Quality automation details

*The pipeline does the boring stuff automatically so you can focus on building great features.*
