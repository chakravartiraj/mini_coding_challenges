# ⚙️ Environment Setup

> **Get your development environment ready for Flutter development**

## 🎯 What You Need

To develop the Mini Coding Challenges app, install:
- **Flutter SDK** (3.16.9 or newer)
- **Java Development Kit** (JDK 17 or newer)
- **Android Studio** or **VS Code**
- **Git** for version control

## 🔧 Step-by-Step Setup

### **1. Install Flutter (10 minutes)**

**Download Flutter:**
```bash
# macOS/Linux - using git
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Windows - download ZIP from flutter.dev
# Extract and add to PATH
```

**Verify Installation:**
```bash
flutter doctor
# Should show Flutter version 3.16.9+
```

### **2. Install Java JDK (5 minutes)**

**Option A: Using Package Manager**
```bash
# macOS with Homebrew
brew install openjdk@17

# Ubuntu/Debian
sudo apt install openjdk-17-jdk

# Windows - download from Oracle or use Chocolatey
choco install openjdk17
```

**Option B: Manual Download**
- Download JDK 17+ from [Oracle](https://www.oracle.com/java/technologies/downloads/)
- Install and add to PATH

**Verify Installation:**
```bash
java -version
# Should show version 17 or higher
```

### **3. Install Android Studio (15 minutes)**

**Download and Install:**
1. Download from [developer.android.com](https://developer.android.com/studio)
2. Install with default settings
3. Open Android Studio → Install SDK components

**Configure Android SDK:**
```bash
# Accept licenses
flutter doctor --android-licenses

# Verify setup
flutter doctor
# Should show ✓ for Android toolchain
```

### **4. Install VS Code (Optional but Recommended)**

**Install Extensions:**
1. **Flutter** - Official Flutter support
2. **Dart** - Dart language support  
3. **Bracket Pair Colorizer** - Better code readability
4. **GitLens** - Enhanced Git integration

**Verify Setup:**
```bash
# Open project in VS Code
code .

# Should detect Flutter project and offer to get dependencies
```

### **5. Verify Complete Setup**

**Run Flutter Doctor:**
```bash
flutter doctor -v
```

**Expected Output:**
```
✓ Flutter (Channel stable, 3.16.9+)
✓ Android toolchain - develop for Android devices
✓ Chrome - develop for the web
✓ Android Studio (version 2023.1+)
✓ VS Code (version 1.80+)
✓ Connected device (if device connected)
```

## 🚀 Quick Project Setup

### **Clone and Run**
```bash
# Clone the project
git clone <repository-url>
cd mini_coding_challenges

# Get dependencies
flutter pub get

# Run the app
flutter run
```

**That's it!** The app should build and run.

## 🛠️ Platform-Specific Setup

### **Android Development**

**Required:**
- Android Studio with SDK
- Android device or emulator

**Optional Setup:**
```bash
# Enable developer mode on physical device
# Settings → About Phone → Tap Build Number 7 times

# Enable USB debugging  
# Settings → Developer Options → USB Debugging
```

### **iOS Development** (macOS only)

**Required:**
- Xcode (latest version)
- iOS Simulator or physical device

**Setup:**
```bash
# Install Xcode command line tools
sudo xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept

# Install CocoaPods
sudo gem install cocoapods
```

### **Web Development**

**Setup:**
```bash
# Enable web support
flutter config --enable-web

# Run on web
flutter run -d chrome
```

## 🔍 Verify Everything Works

### **Test Flutter Installation**
```bash
# Check Flutter
flutter --version

# Check dependencies
flutter doctor

# Create test project
flutter create test_app
cd test_app
flutter run
```

### **Test Project-Specific Setup**
```bash
# In mini_coding_challenges directory
flutter clean
flutter pub get
flutter analyze  # Should show no issues
flutter test     # Should pass all tests
flutter run      # Should build and run
```

## ⚡ Development Tools Setup

### **Useful CLI Tools**
```bash
# Install useful tools
dart pub global activate fvm          # Flutter Version Management
dart pub global activate very_good_cli # Flutter project scaffolding
```

### **Git Configuration**
```bash
# Configure git (if not done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set up pre-commit hooks (optional)
ln -sf ../../scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
```

### **IDE Configuration**

**VS Code Settings (Optional):**
```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "dart.closingLabels": true,
  "editor.rulers": [80],
  "editor.formatOnSave": true
}
```

## 🧹 Clean Environment

### **Reset Flutter**
```bash
# Clean Flutter cache
flutter clean
rm -rf ~/.pub-cache  # Nuclear option

# Reinstall dependencies
flutter pub get
```

### **Reset Android**
```bash
# Clean Android builds
cd android
./gradlew clean
cd ..

# Reset Android Studio cache
# Android Studio → File → Invalidate Caches and Restart
```

## 📊 Environment Variables

### **Required Environment Variables**
```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export PATH="$PATH:/path/to/flutter/bin"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
export JAVA_HOME="/path/to/java"
```

### **Project-Specific Variables**
```bash
# Create .env file for local development
FLUTTER_DEBUG=true
ANDROID_KEYSTORE_PATH=/path/to/keystore.jks
```

## 🆘 Need Help?

If setup doesn't work:
1. **[Troubleshooting Guide](../troubleshooting/TROUBLESHOOTING_GUIDE_COMPLETE.md)** - Common setup issues
2. **[Flutter Doctor Issues](../troubleshooting/SETUP_ISSUES.md)** - Specific Flutter problems
3. **Flutter Official Docs** - [docs.flutter.dev](https://docs.flutter.dev)

## ➡️ Next Steps

After setup is complete:
1. **[Quick Start](../QUICK_START_GUIDE.md)** - Run the app in 5 minutes
2. **[Architecture Overview](../architecture/ARCHITECTURE_OVERVIEW_GUIDE.md)** - Understand the codebase
3. **[Build Guide](../build/BUILD_PROCESS_OVERVIEW.md)** - Learn to build the app

*Good setup makes everything else easier - take time to get it right!*
