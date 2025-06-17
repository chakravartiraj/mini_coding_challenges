# 🚀 Quick Setup Guide - Flutter CI/CD Pipeline

## ⚡ 5-Minute Setup

### 1. Prerequisites Check
```bash
# Verify required tools
flutter --version  # Should be 3.16.9+
java -version      # Should be 17+
ruby --version     # Should be 3.1+
git --version      # Any recent version
```

### 2. Install Dependencies
```bash
# Flutter dependencies
flutter pub get

# Fastlane dependencies
cd android
bundle install
cd ..
```

### 3. Test the Pipeline Locally
```bash
# Run pre-commit checks
./scripts/pre-commit-quality-check.sh

# Run full Fastlane pipeline
cd android
bundle exec fastlane --file QualityFastfile master_quality_pipeline
```

### 4. Setup Git Hook (Optional)
```bash
# Automatic pre-commit checks
ln -sf ../../scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
```

### 5. Push to Trigger CI/CD
```bash
git add .
git commit -m "feat: setup professional CI/CD pipeline"
git push origin main
```

## 🎯 What Happens Next

1. **GitHub Actions triggers** automatically
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
