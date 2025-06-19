# ⚡ Quick Setup - Flutter CI/CD Pipeline

## 🚀 5-Minute Setup

### 1. Prerequisites
```bash
flutter --version  # 3.16.9+
java -version      # 17+
ruby --version     # 3.1+
```

### 2. Install Dependencies
```bash
flutter pub get
cd android && bundle install && cd ..
```

### 3. Test Locally (Optional)
```bash
# Pre-commit validation
./scripts/pre-commit-quality-check.sh

# Full pipeline test
cd android && bundle exec fastlane --file QualityFastfile master_quality_pipeline
```

### 4. Setup Pre-commit Hook (Optional)
```bash
ln -sf ../../scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
```

### 5. Trigger CI/CD
```bash
git add .
git commit -m "feat: setup CI/CD pipeline"
git push origin main
```

## 🎯 What Happens

**GitHub Actions Pipeline** (25-45 min):
1. Static Analysis & Formatting (~5-10 min)
2. Testing Suite (~15-20 min)
3. Coverage Analysis (~5-10 min)
4. Performance Monitoring (~10-15 min)
5. Build Artifacts (~15-25 min)
6. Quality Summary (~5 min)

## 📊 Expected Outputs

### **Local Reports** (after Fastlane run)
```
reports/
├── analysis/     # Static analysis
├── tests/        # Test results  
├── coverage/     # HTML coverage
├── performance/  # Build metrics
└── build/        # Build summaries
```

### **GitHub Artifacts**
- Analysis Reports
- Test Reports (all types)
- Coverage Reports (HTML)
- Performance Reports
- Build Artifacts (APK/AAB)

## 🔧 Common Issues

**Flutter not found:** Add to PATH  
**Bundle install fails:** `gem install bundler`  
**Java version wrong:** Install OpenJDK 17  
**No tests found:** Tests auto-created on first run  

## 📚 Next Steps

- **Customize:** Edit `android/fastlane/QualityFastfile`
- **Documentation:** See [Complete CI/CD Guide](CICD_PIPELINE_COMPLETE_GUIDE.md)
- **Issues:** Check [troubleshooting section](CI_CD_PIPELINE_GUIDE.md#troubleshooting)

**Done! Push code to see your pipeline in action!** 🚀
2. **Static analysis** runs first (~5 min)
3. **Tests execute** in parallel (~15 min)
4. **Coverage analysis** generates reports (~5 min)
5. **Performance monitoring** tracks metrics (~10 min)
6. **Build artifacts** are generated (~20 min)
7. **Quality summary** is created (~5 min)

## 📊 Expected Outputs

### Local Reports (after running Fastlane)
```
reports/
├── analysis/          # Static analysis results
├── tests/            # Test execution results
├── coverage/         # Coverage HTML reports
├── performance/      # Performance metrics
├── build/           # Build summaries
└── QUALITY_SUMMARY.md
```

### GitHub Actions Artifacts
- **Analysis Reports** - Static analysis and formatting
- **Test Reports** - All test type results
- **Coverage Reports** - HTML coverage reports
- **Performance Reports** - Build metrics
- **Build Artifacts** - APK and App Bundle files

## 🔧 Common First-Run Issues

### Issue: "Flutter not found"
```bash
# Solution: Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
# Add to ~/.bashrc or ~/.zshrc for persistence
```

### Issue: "Bundle install fails"
```bash
# Solution: Install Ruby and Bundler
sudo apt-get install ruby-full  # Linux
brew install ruby              # macOS
gem install bundler
```

### Issue: "Java version mismatch"
```bash
# Solution: Install Java 17
sudo apt-get install openjdk-17-jdk  # Linux
brew install openjdk@17              # macOS
```

### Issue: "No tests found"
```bash
# Solution: Create basic test structure
mkdir -p test/unit test/widget test/integration test/golden
# Tests will be auto-created on first run
```

## 🎛️ Immediate Customization

### Adjust Coverage Threshold
Edit `android/fastlane/QualityFastfile`:
```ruby
# Line ~200: Change coverage threshold
if coverage_percent < 70.0  # Change from 80 to 70
```

### Skip Performance Tests
In GitHub workflow, set input:
```yaml
run_performance_tests: false
```

### Change Flutter Version
Edit `.github/workflows/quality-first-pipeline.yml`:
```yaml
env:
  FLUTTER_VERSION: '3.19.0'  # Update as needed
```

## 📋 Verification Checklist

After setup, verify:

- [ ] Pre-commit script runs without errors
- [ ] Local Fastlane pipeline completes successfully
- [ ] GitHub Actions workflow triggers on push
- [ ] All pipeline stages pass (green checkmarks)
- [ ] Artifacts are generated and downloadable
- [ ] Reports are comprehensive and readable

## 🎉 You're Done!

Your Flutter project now has:

✅ **Professional CI/CD Pipeline**  
✅ **Automated Quality Checks**  
✅ **Comprehensive Testing**  
✅ **Performance Monitoring**  
✅ **Build Automation**  
✅ **Detailed Reporting**  

## 📞 Next Steps

1. **Customize** the pipeline for your specific needs
2. **Add more tests** to increase coverage
3. **Configure** quality thresholds
4. **Integrate** with your development workflow
5. **Share** with your team

📖 **Full Documentation:** `docs/CI_CD_PIPELINE_GUIDE.md`

Happy coding! 🚀

## 🔨 Debug Build Workflow

### **Quick Debug Build**
```bash
# Trigger debug build with dynamic versioning
git push origin feature/my-feature
# → Generates versioned APK & AAB artifacts automatically
```

### **Manual Debug Build**
1. Go to **Actions** → **Debug Build with Dynamic Versioning**
2. Click **Run workflow**
3. Optionally add version suffix
4. Download artifacts when complete

### **Local Debug Build**
```bash
# Build locally with same versioning system
./scripts/build-debug-local.sh

# With custom suffix
./scripts/build-debug-local.sh hotfix
```

📖 **Complete Guide**: [Debug Build Workflow Documentation](DEBUG_BUILD_WORKFLOW.md)

## 🎯 What Happens

**Debug Build Workflow** (5-15 min):
1. Version Bump & Tagging (~2-5 min)
2. Build APK & AAB (~5-10 min)
3. Upload to Firebase (~3-5 min)
4. Notify Stakeholders (~1-2 min)

### Expected Outputs
- Versioned APK and AAB files
- Firebase distribution links
- Notification of completion
