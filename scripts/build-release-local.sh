#!/bin/bash

# Local Release Build Script with Fastlane and Timestamped Artifacts
# This script builds release APK and AAB artifacts using Fastlane with dynamic versioning
#
# USAGE - Easy Ways to Run This Script:
# =====================================
#
# 1. From Project Root (Traditional):
#    cd /path/to/mini_coding_challenges
#    ./scripts/build-release-local.sh
#
# 2. From Scripts Directory (Auto-detects project root):
#    cd /path/to/mini_coding_challenges/scripts
#    ./build-release-local.sh
#
# 3. Direct Path (From anywhere):
#    /path/to/mini_coding_challenges/scripts/build-release-local.sh
#
# 4. Using Relative Path (if you're in project or subdirectory):
#    ./scripts/build-release-local.sh
#    # or
#    ../scripts/build-release-local.sh
#
# 5. Create an Alias (Add to ~/.bashrc):
#    alias build-release='cd /path/to/mini_coding_challenges && ./scripts/build-release-local.sh'
#    # Then just run: build-release
#
# REQUIREMENTS:
# - Flutter SDK installed
# - Fastlane installed (gem install fastlane --user-install)
# - Android SDK configured
# - Ruby with native extensions support
# - Release keystore configured in android/key.properties
# - Signing credentials properly set up
#
# OUTPUT:
# - Timestamped APK files in build/app/outputs/apk/
# - Timestamped AAB files in build/app/outputs/bundle/release/
# - Build metadata files in project root
#
# EXAMPLES:
# =========
# # Quick start from anywhere:
# /home/io/StudioProjects/mini_coding_challenges/scripts/build-release-local.sh
#
# # If you're already in the project:
# ./scripts/build-release-local.sh
#
# # If you're in the scripts directory:
# ./build-release-local.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')] ✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date '+%H:%M:%S')] ⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}[$(date '+%H:%M:%S')] ❌${NC} $1"
}

# Determine the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Change to project root if not already there
if [ "$(pwd)" != "$PROJECT_ROOT" ]; then
    print_message "📂 Changing to project root: $PROJECT_ROOT"
    cd "$PROJECT_ROOT"
fi

# Check if we're in the project root
if [ ! -f "pubspec.yaml" ]; then
    print_error "Error: pubspec.yaml not found at $PROJECT_ROOT"
    print_error "This doesn't appear to be a Flutter project root."
    exit 1
fi

# Check if Fastlane is available
if ! command -v fastlane &> /dev/null; then
    print_error "Fastlane not found. Please install it:"
    echo "  gem install fastlane --user-install"
    exit 1
fi

# Check if keystore configuration exists
if [ ! -f "android/key.properties" ]; then
    print_error "Release keystore configuration not found!"
    print_error "Please create android/key.properties with your release keystore settings:"
    echo ""
    echo "  storePassword=your_store_password"
    echo "  keyPassword=your_key_password"
    echo "  keyAlias=your_key_alias"
    echo "  storeFile=path/to/your/keystore.jks"
    echo ""
    print_warning "You can create a keystore using: ./scripts/create-keystore.sh"
    exit 1
fi

# Validate keystore configuration
print_message "🔍 Validating keystore configuration..."
if ! cd android && fastlane validate 2>/dev/null; then
    print_error "Keystore validation failed!"
    print_error "Please check your android/key.properties file and keystore."
    print_warning "Make sure your keystore file exists and credentials are correct."
    exit 1
fi
cd ..

print_message "🚀 Starting release build with Fastlane..."
print_warning "📝 Note: This will create signed release artifacts"

# Change to android directory and run Fastlane
cd android

print_message "📦 Building release artifacts with dynamic versioning..."
if fastlane build_release_artifacts; then
    print_success "Fastlane release build completed successfully!"
else
    print_error "Fastlane release build failed"
    exit 1
fi

# Return to project root
cd ..

# Create timestamped copies in the correct locations
print_message "🔄 Creating timestamped artifact copies in correct locations..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
GIT_COMMIT=$(git rev-parse --short HEAD)

# Ensure target directories exist
mkdir -p "build/app/outputs/apk"
mkdir -p "build/app/outputs/bundle/release"

# Copy APK to correct location with timestamp
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    TIMESTAMPED_APK="build/app/outputs/apk/app-release-${TIMESTAMP}-${GIT_COMMIT}.apk"
    cp "build/app/outputs/flutter-apk/app-release.apk" "$TIMESTAMPED_APK"
    print_success "APK copied to: $TIMESTAMPED_APK"
elif [ -f "build/app/outputs/apk/release/app-release.apk" ]; then
    TIMESTAMPED_APK="build/app/outputs/apk/app-release-${TIMESTAMP}-${GIT_COMMIT}.apk"
    cp "build/app/outputs/apk/release/app-release.apk" "$TIMESTAMPED_APK"
    print_success "APK copied to: $TIMESTAMPED_APK"
else
    print_error "Release APK not found in expected locations"
fi

# Copy AAB to correct location with timestamp
if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    TIMESTAMPED_AAB="build/app/outputs/bundle/release/app-release-${TIMESTAMP}-${GIT_COMMIT}.aab"
    if [ ! -f "$TIMESTAMPED_AAB" ]; then
        cp "build/app/outputs/bundle/release/app-release.aab" "$TIMESTAMPED_AAB"
        print_success "AAB copied to: $TIMESTAMPED_AAB"
    else
        print_message "Timestamped AAB already exists: $TIMESTAMPED_AAB"
    fi
else
    print_error "Release AAB not found: build/app/outputs/bundle/release/app-release.aab"
fi

# Display build summary
print_message "📋 Build Summary:"
echo ""

if [ -f "build_info.json" ]; then
    echo "📄 Build Information:"
    cat build_info.json | jq '.' 2>/dev/null || cat build_info.json
    echo ""
fi

echo "📦 Generated Release Artifacts:"
if [ -f "$TIMESTAMPED_APK" ]; then
    APK_SIZE=$(du -h "$TIMESTAMPED_APK" | cut -f1)
    echo "  📱 Timestamped APK: $TIMESTAMPED_APK (${APK_SIZE})"
fi

if [ -f "$TIMESTAMPED_AAB" ]; then
    AAB_SIZE=$(du -h "$TIMESTAMPED_AAB" | cut -f1)
    echo "  📦 Timestamped AAB: $TIMESTAMPED_AAB (${AAB_SIZE})"
fi

echo ""
print_success "🎉 Release build completed successfully!"
print_message "Timestamped artifacts are in the requested locations:"
print_message "  • APK: build/app/outputs/apk/"
print_message "  • AAB: build/app/outputs/bundle/release/"

# Security reminder
echo ""
print_warning "🔒 Security Reminder:"
print_warning "  • Release artifacts are signed with your production keystore"
print_warning "  • Keep your keystore and passwords secure"
print_warning "  • Test thoroughly before distributing"
print_warning "  • Consider using Play App Signing for production releases"
