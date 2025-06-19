# 🛠️ Troubleshooting Guide

> **Fix common problems when developing the Mini Coding Challenges app**

## 🚨 Quick Fixes

### **App Won't Build**
```bash
# Try the flutter clean dance
flutter clean
flutter pub get
flutter run
```

### **Dependencies Issues**
```bash
# Clear pub cache
flutter pub cache clean
flutter pub get

# Nuclear option
rm -rf ~/.pub-cache
flutter pub get
```

### **Android Build Fails**
```bash
# Clean Android builds
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

## 📱 Setup Issues

### **Flutter Doctor Problems**

**❌ "Flutter not found"**
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Make permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
```

**❌ "Android license not accepted"**
```bash
# Accept all Android licenses
flutter doctor --android-licenses
# Type 'y' for all prompts
```

**❌ "Java not found" or wrong version**
```bash
# Check Java version
java -version

# Install correct version
# macOS: brew install openjdk@17
# Ubuntu: sudo apt install openjdk-17-jdk
# Windows: Download from Oracle

# Set JAVA_HOME
export JAVA_HOME=/path/to/java
```

**❌ "Android SDK not found"**
```bash
# Set Android SDK path
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Or set in Android Studio
# File → Project Structure → SDK Location
```

### **VS Code Issues**

**❌ Flutter extension not working**
1. Install Flutter and Dart extensions
2. Reload VS Code (Cmd/Ctrl + Shift + P → "Reload Window")
3. Select Flutter SDK path (Cmd/Ctrl + Shift + P → "Flutter: Change SDK")

**❌ "No devices found"**
```bash
# Check connected devices
flutter devices

# Start Android emulator
# Android Studio → AVD Manager → Start emulator

# Or use Chrome for web
flutter run -d chrome
```

## 🔨 Build Problems

### **Gradle Build Failures**

**❌ "Gradle sync failed"**
```bash
# Clean Gradle cache
cd android
./gradlew clean
rm -rf .gradle
cd ..
flutter clean
flutter run
```

**❌ "compileSdkVersion" errors**
```bash
# Update compileSdkVersion in android/app/build.gradle
android {
    compileSdkVersion 34  // Use latest
    ...
}
```

**❌ "Minimum SDK version" errors**
```bash
# Update minSdkVersion in android/app/build.gradle
android {
    defaultConfig {
        minSdkVersion 21  // Or higher
        ...
    }
}
```

### **iOS Build Failures** (macOS only)

**❌ "Xcode not found"**
```bash
# Install Xcode from App Store
# Then set command line tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

**❌ "CocoaPods errors"**
```bash
# Update CocoaPods
sudo gem install cocoapods

# Clean and reinstall pods
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

**❌ "iOS deployment target" errors**
```bash
# Update iOS deployment target in ios/Podfile
platform :ios, '12.0'  # Or higher
```

## 🌐 Network & API Issues

### **API Connection Problems**

**❌ "Connection refused" or "Network error"**
```bash
# Check internet connection
ping google.com

# For Android emulator, use 10.0.2.2 instead of localhost
# For iOS simulator, use localhost or 127.0.0.1
```

**❌ "SSL Certificate errors"**
```bash
# For development only - disable certificate validation
# (Not for production!)
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

// In main()
HttpOverrides.global = MyHttpOverrides();
```

**❌ "CORS errors" (Web only)**
```bash
# Run with CORS disabled (development only)
flutter run -d chrome --web-renderer html --web-browser-flag "--disable-web-security"
```

## 🎯 State Management Issues

### **BLoC Problems**

**❌ "BLoC not found"**
```dart
// Make sure BLoC is provided
BlocProvider<TransactionsBloc>(
  create: (context) => GetIt.instance<TransactionsBloc>(),
  child: MyWidget(),
)

// Or use MultiBlocProvider for multiple BLoCs
MultiBlocProvider(
  providers: [
    BlocProvider<TransactionsBloc>(create: (context) => GetIt.instance()),
    // ... other providers
  ],
  child: MyApp(),
)
```

**❌ "State not updating"**
```dart
// Ensure you're emitting new state objects
// ❌ Wrong - modifying existing state
state.transactions.add(newTransaction);
emit(state);

// ✅ Correct - creating new state
emit(state.copyWith(
  transactions: [...state.transactions, newTransaction],
));
```

**❌ "Memory leaks" with BLoC**
```dart
// Always close BLoCs when done
@override
void dispose() {
  _transactionsBloc.close();
  super.dispose();
}

// Or use BlocProvider which handles disposal automatically
```

## 🧪 Testing Issues

### **Test Failures**

**❌ "Widget test fails to pump"**
```dart
// Wrap widgets in MaterialApp for testing
await tester.pumpWidget(
  MaterialApp(
    home: MyWidget(),
  ),
);
```

**❌ "BLoC test doesn't emit expected states"**
```dart
// Use blocTest package for easier BLoC testing
blocTest<MyBloc, MyState>(
  'description',
  build: () => MyBloc(),
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [ExpectedState()],
);
```

**❌ "Integration test fails on CI"**
```bash
# Increase timeouts for CI
flutter test integration_test/ --timeout=120s
```

## 🔧 Performance Issues

### **App Running Slowly**

**❌ "App is laggy"**
```bash
# Build in release mode for performance testing
flutter run --release

# Enable performance overlay to see FPS
# In app: Add performance overlay in debug builds
```

**❌ "Large app size"**
```bash
# Build optimized release
flutter build apk --release --shrink

# Analyze app size
flutter build apk --analyze-size
```

**❌ "High memory usage"**
```dart
// Dispose controllers and streams
@override
void dispose() {
  _controller.dispose();
  _streamSubscription.cancel();
  super.dispose();
}

// Use const constructors when possible
const MyWidget();
```

## 🔍 Debugging Tips

### **Debug Tools**

**Enable debugging:**
```dart
// Debug prints
debugPrint('Debug message: $data');

// Inspector (VS Code: Cmd+Shift+P → "Flutter: Open Widget Inspector")

// Performance overlay
MaterialApp(
  debugShowMaterialGrid: true,  // Show material grid
  showPerformanceOverlay: true, // Show FPS
  ...
)
```

**Use Flutter Inspector:**
```bash
# Open Flutter Inspector in browser
flutter inspector

# Or in VS Code: Cmd+Shift+P → "Flutter: Open Widget Inspector"
```

### **Logging**

**Add proper logging:**
```dart
import 'package:logging/logging.dart';

final _logger = Logger('MyClass');

_logger.info('Information message');
_logger.warning('Warning message');
_logger.severe('Error message');
```

## 🆘 Still Stuck?

### **Getting Help**

1. **Check Flutter doctor:** `flutter doctor -v`
2. **Search Flutter issues:** [github.com/flutter/flutter/issues](https://github.com/flutter/flutter/issues)
3. **Stack Overflow:** [stackoverflow.com/questions/tagged/flutter](https://stackoverflow.com/questions/tagged/flutter)
4. **Flutter Discord:** [discord.gg/flutter](https://discord.gg/flutter)

### **Reset Everything** (Nuclear option)
```bash
# Delete Flutter cache
rm -rf ~/.pub-cache

# Delete project dependencies
flutter clean
rm -rf .dart_tool
rm pubspec.lock

# Reinstall everything
flutter pub get
flutter run
```

### **Create Minimal Reproduction**
If you find a bug:
1. Create a minimal Flutter app that reproduces the issue
2. Share code and error messages
3. Include `flutter doctor -v` output
4. Specify exact steps to reproduce

## ➡️ Prevention

### **Avoid Common Issues**
- **Keep Flutter updated:** `flutter upgrade`
- **Use stable channel:** `flutter channel stable`
- **Regular cleanup:** `flutter clean` weekly
- **Version control:** Commit working states frequently
- **Test on multiple devices:** Different screen sizes and OS versions

*When in doubt, clean and rebuild - it fixes 80% of issues!*
