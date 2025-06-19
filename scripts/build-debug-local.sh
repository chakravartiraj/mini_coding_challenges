#!/bin/bash

# Local Debug Build Script with Fastlane and Timestamped Artifacts
# This script builds debug APK and AAB artifacts using Fastlane with dynamic versioning
#
# USAGE - Easy Ways to Run This Script:
# =====================================
#
# 1. From Project Root (Traditional):
#    cd /path/to/mini_coding_challenges
#    ./scripts/build-debug-local.sh
#
# 2. From Scripts Directory (Auto-detects project root):
#    cd /path/to/mini_coding_challenges/scripts
#    ./build-debug-local.sh
#
# 3. Direct Path (From anywhere):
#    /path/to/mini_coding_challenges/scripts/build-debug-local.sh
#
# 4. Using Relative Path (if you're in project or subdirectory):
#    ./scripts/build-debug-local.sh
#    # or
#    ../scripts/build-debug-local.sh
#
# 5. Create an Alias (Add to ~/.bashrc):
#    alias build-debug='cd /path/to/mini_coding_challenges && ./scripts/build-debug-local.sh'
#    # Then just run: build-debug
#
# REQUIREMENTS:
# - Flutter SDK installed
# - Fastlane installed (gem install fastlane --user-install)
# - Android SDK configured
# - Ruby with native extensions support
#
# OUTPUT:
# - Timestamped APK files in build/app/outputs/apk/
# - Timestamped AAB files in build/app/outputs/bundle/debug/
# - Build metadata files in project root
#
# EXAMPLES:
# =========
# # Quick start from anywhere:
# /home/io/StudioProjects/mini_coding_challenges/scripts/build-debug-local.sh
#
# # If you're already in the project:
# ./scripts/build-debug-local.sh
#
# # If you're in the scripts directory:
# ./build-debug-local.sh
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

print_message "🚀 Starting debug build with Fastlane..."

# Change to android directory and run Fastlane
cd android

print_message "📦 Building debug artifacts with dynamic versioning..."
if fastlane build_debug_artifacts; then
    print_success "Fastlane build completed successfully!"
else
    print_error "Fastlane build failed"
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
mkdir -p "build/app/outputs/bundle/debug"

# Copy APK to correct location with timestamp
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    TIMESTAMPED_APK="build/app/outputs/apk/app-debug-${TIMESTAMP}-${GIT_COMMIT}.apk"
    cp "build/app/outputs/flutter-apk/app-debug.apk" "$TIMESTAMPED_APK"
    print_success "APK copied to: $TIMESTAMPED_APK"
elif [ -f "build/app/outputs/apk/debug/app-debug.apk" ]; then
    TIMESTAMPED_APK="build/app/outputs/apk/app-debug-${TIMESTAMP}-${GIT_COMMIT}.apk"
    cp "build/app/outputs/apk/debug/app-debug.apk" "$TIMESTAMPED_APK"
    print_success "APK copied to: $TIMESTAMPED_APK"
else
    print_error "APK not found in expected locations"
fi

# Copy AAB to correct location with timestamp (already in correct location)
if [ -f "build/app/outputs/bundle/debug/app-debug.aab" ]; then
    TIMESTAMPED_AAB="build/app/outputs/bundle/debug/app-debug-${TIMESTAMP}-${GIT_COMMIT}.aab"
    if [ ! -f "$TIMESTAMPED_AAB" ]; then
        cp "build/app/outputs/bundle/debug/app-debug.aab" "$TIMESTAMPED_AAB"
        print_success "AAB copied to: $TIMESTAMPED_AAB"
    else
        print_message "Timestamped AAB already exists: $TIMESTAMPED_AAB"
    fi
else
    print_error "AAB not found: build/app/outputs/bundle/debug/app-debug.aab"
fi

# Display build summary
print_message "📋 Build Summary:"
echo ""

if [ -f "build_info.json" ]; then
    echo "📄 Build Information:"
    cat build_info.json | jq '.' 2>/dev/null || cat build_info.json
    echo ""
fi

echo "📦 Generated Artifacts:"
if [ -f "$TIMESTAMPED_APK" ]; then
    APK_SIZE=$(du -h "$TIMESTAMPED_APK" | cut -f1)
    echo "  📱 Timestamped APK: $TIMESTAMPED_APK (${APK_SIZE})"
fi

if [ -f "$TIMESTAMPED_AAB" ]; then
    AAB_SIZE=$(du -h "$TIMESTAMPED_AAB" | cut -f1)
    echo "  📦 Timestamped AAB: $TIMESTAMPED_AAB (${AAB_SIZE})"
fi

echo ""
print_success "🎉 Debug build completed successfully!"
print_message "Timestamped artifacts are in the requested locations:"
print_message "  • APK: build/app/outputs/apk/"
print_message "  • AAB: build/app/outputs/bundle/debug/"
