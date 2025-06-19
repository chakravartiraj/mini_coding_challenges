# 🔧 Debug Builds

> **Build development versions with automatic versioning and debugging features**

## 🎯 What Are Debug Builds?

Debug builds are for development and testing:
- **Fast compilation** - Quick to build and deploy
- **Debugging enabled** - Can use breakpoints and debugging tools
- **Auto-versioning** - Automatically generates version numbers
- **Debug keystore** - Uses Flutter's built-in debug signing

## 🚀 Quick Debug Build

### **Run and Test**
```bash
# Build and run on connected device
flutter run

# Build APK only (don't install)
flutter build apk --debug
```

### **Using Build Scripts** (Recommended)
```bash
# Automated debug build with versioning
./scripts/build-debug-local.sh

# Or if shell functions are set up
build-debug
```

## 🔄 Automatic Versioning

The debug build scripts automatically:
- **Generate version numbers** based on timestamp
- **Include build info** in APK name
- **Copy artifacts** to organized folders

Example output:
```
app-debug-1.0.0+20241127-143052.apk
```

## 📁 Build Outputs

After building, find your files:
```
build/app/outputs/flutter-apk/
├── app-debug.apk                    # Latest debug APK
└── app-debug-arm64-v8a.apk         # Architecture-specific

artifacts/debug/                     # If using build scripts
├── builds/2024-11-27_14-30-52/    # Timestamped builds
└── current/                        # Latest build symlink
```

## 🛠️ Advanced Debug Options

### **Hot Reload Development**
```bash
# Start with hot reload
flutter run

# In running session:
# r - hot reload
# R - hot restart  
# q - quit
```

### **Debug with Specific Device**
```bash
# List devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### **Debug Build with Logging**
```bash
# Enable verbose logging
flutter run --verbose

# Debug APK with verbose
flutter build apk --debug --verbose
```

## 🔍 Debug Build Verification

### **Check Build Success**
```bash
# Verify APK exists
ls -la build/app/outputs/flutter-apk/app-debug.apk

# Check APK size (debug is larger)
ls -lh build/app/outputs/flutter-apk/app-debug.apk
```

### **Install and Test**
```bash
# Install on connected device
flutter install

# Or manually install APK
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### **Verify Debug Features**
- **Hot reload works** - Make a change, press 'r'
- **Debug info available** - Check logs and debugging
- **Performance overlay** - Shows FPS and memory usage

## 🐛 Debug Build Troubleshooting

### **Build Fails**
```bash
# Clean and retry
flutter clean
flutter pub get
flutter build apk --debug
```

### **Can't Install APK**
```bash
# Check device connection
adb devices

# Enable developer mode on device
# Settings > About Phone > Tap Build Number 7 times
```

### **Hot Reload Not Working**
```bash
# Restart with hot reload enabled
flutter run --hot
```

## ⚡ Quick Debug Workflows

### **Daily Development**
```bash
# Start development session
flutter run

# Make changes, test with hot reload (r)
# When satisfied, hot restart (R) to test full app
```

### **Build for Testing**
```bash
# Create debug APK for testing
./scripts/build-debug-local.sh

# Share with testers
# File: build/app/outputs/flutter-apk/app-debug.apk
```

## 📊 Build Scripts Features

If using `./scripts/build-debug-local.sh`:
- **Automatic versioning** with timestamps
- **Organized artifact storage** in `artifacts/debug/`
- **Build metadata** generation
- **Works from any directory** (auto-detects project root)

See **[Build Script Usage](../BUILD_SCRIPTS_USAGE_GUIDE.md)** for complete documentation.

## ➡️ Next Steps

- **[Release Builds](RELEASE_BUILD_GUIDE.md)** - When ready for production
- **[Testing Guide](../testing/TESTING_GUIDE_OVERVIEW.md)** - Run automated tests
- **[Android Signing](ANDROID_KEYSTORE_SIGNING_GUIDE.md)** - Set up for release builds

*Debug builds are your daily driver - use them for all development and testing.*
