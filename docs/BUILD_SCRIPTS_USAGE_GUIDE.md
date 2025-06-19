# 🚀 How to Run Build Scripts - Quick Reference

This guide shows the easiest ways to run the debug and release build scripts in the Mini Coding Challenges project.

## 📋 Table of Contents
- [Quick Start](#quick-start)
- [Debug Builds](#debug-builds)
- [Release Builds](#release-builds)
- [All Methods](#all-methods)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## 🏃 Quick Start

### **Debug Build (Simplest Method):**
```bash
# Just run this from any directory:
/home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh
```

### **Release Build (Requires Keystore):**
```bash
# Make sure keystore is configured first, then:
/home/io/StudioProjects/mini_coding_challenges/scripts/build-release-local.sh
```

### **If you're already in the project:**
```bash
cd /home/io/StudioProjects/mini_coding_challenges
./scripts/build-debug-local.sh   # Debug
./scripts/build-release-local.sh # Release
```

## 🛠️ Debug Builds

Debug builds are unsigned and used for development and testing.

### **Quick Methods:**
```bash
# Method 1: From anywhere (absolute path)
/home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh

# Method 2: From project root
cd /home/io/StudioProjects/mini_coding_challenges
./scripts/build-debug-local.sh

# Method 3: From scripts directory
cd /home/io/StudioProjects/mini_coding_challenges/scripts
./build-debug-local.sh
```

### **Method 4: Relative Path (Context-dependent)**
```bash
# If you're in the project root:
./scripts/build-debug-local.sh

# If you're one level deep (like in lib/, android/, etc.):
../scripts/build-debug-local.sh

# If you're two levels deep:
../../scripts/build-debug-local.sh
```
✅ **Pros:** Short command  
⚠️ **Cons:** Depends on your current location

### **Method 5: Create an Alias (Super Convenient)**
Add this line to your `~/.bashrc` or `~/.bash_profile`:
```bash
alias build-debug='cd /home/io/StudioProjects/mini_coding_challenges && ./scripts/build-debug-local.sh'
```

Then reload your shell or run `source ~/.bashrc`, and use:
```bash
build-debug
```
✅ **Pros:** Super short command  
✅ **Pros:** Works from anywhere  
⚠️ **Cons:** One-time setup required

### **Method 6: Using Function (Advanced)**
Add this to your `~/.bashrc`:
```bash
build_debug() {
    local project_dir="/home/io/StudioProjects/mini_coding_challenges"
    echo "🚀 Building debug artifacts..."
    (cd "$project_dir" && ./scripts/build-debug-local.sh "$@")
}
```
Then use:
```bash
build_debug
```

## 🚀 Release Builds

Release builds are signed with your production keystore for distribution.

### **Prerequisites:**
- Configured keystore file
- `android/key.properties` file with signing credentials
- Valid signing certificates

### **Quick Methods:**
```bash
# Method 1: From anywhere (absolute path)
/home/io/StudioProjects/mini_coding_challenges/scripts/build-release-local.sh

# Method 2: From project root
cd /home/io/StudioProjects/mini_coding_challenges
./scripts/build-release-local.sh

# Method 3: From scripts directory
cd /home/io/StudioProjects/mini_coding_challenges/scripts
./build-release-local.sh
```

### **Keystore Setup:**
If you don't have a keystore configured:
```bash
# Create a new keystore (if needed)
./scripts/create-keystore.sh

# Configure android/key.properties with:
# storePassword=your_store_password
# keyPassword=your_key_password  
# keyAlias=your_key_alias
# storeFile=path/to/your/keystore.jks
```

## 🔧 What the Script Does

The `build-debug-local.sh` script:

1. **Auto-detects Project Root**: Finds the project directory regardless of where you run it
2. **Builds Debug Artifacts**: Creates both APK and AAB files
3. **Dynamic Versioning**: Uses timestamp-based version codes
4. **Organized Output**: Places files in `/outputs/` with timestamps
5. **Metadata Generation**: Creates build info JSON files

### **Output Locations:**
- **APK files**: `build/app/outputs/apk/`
- **AAB files**: `build/app/outputs/bundle/debug/`
- **Build info**: Project root (`build_info.json`, `build_metadata.json`)

## 🛠️ Troubleshooting

### **Error: "pubspec.yaml not found"**
- **Old versions**: Make sure you're running from project root
- **Current version**: This should auto-fix, but check if the script updated properly

### **Error: "Fastlane not found"**
```bash
# Install Fastlane:
gem install fastlane --user-install

# Or with bundler:
bundle install
```

### **Error: "Permission denied"**
```bash
# Make script executable:
chmod +x /home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh
```

### **Script hangs or fails**
- Check that Android SDK is properly configured
- Ensure Ruby has native extensions support
- Try running with verbose output: `bash -x ./scripts/build-debug-local.sh`

## 🚀 Advanced Usage

### **Running with Custom Parameters**
The script supports being run from anywhere and will automatically handle paths.

### **Batch Building**
```bash
# Build multiple times (useful for testing):
for i in {1..3}; do
    echo "Build $i:"
    /home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh
    sleep 5
done
```

### **Background Building**
```bash
# Run in background (careful with this):
nohup /home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh > build.log 2>&1 &
```

### **Verify Results**
After building, verify your artifacts:
```bash
cd /home/io/StudioProjects/mini_coding_challenges
./scripts/verify-builds.sh
```

## 📝 Quick Commands Cheat Sheet

| Scenario | Command |
|----------|---------|
| **Anywhere, anytime** | `/home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh` |
| **From project root** | `./scripts/build-debug-local.sh` |
| **From scripts dir** | `./build-debug-local.sh` |
| **With alias setup** | `build-debug` |
| **Check results** | `./scripts/verify-builds.sh` |

## 🎯 Recommended Workflow

1. **First time**: Use the full path to test
2. **Regular use**: Set up an alias for convenience
3. **Verification**: Always run `verify-builds.sh` after building
4. **CI/CD**: Use the full path in automated scripts

---

**💡 Pro Tip**: The script automatically detects the project root, so you can run it from anywhere without worrying about your current directory!
