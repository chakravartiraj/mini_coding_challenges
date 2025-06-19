#!/bin/bash

echo "🔍 Testing artifact verification script..."

cd /home/io/StudioProjects/mini_coding_challenges

BUILD_TYPE="${1:-debug}"
echo "🔍 Looking for $BUILD_TYPE artifacts..."

# Define all possible APK locations based on build type
if [ "$BUILD_TYPE" = "release" ]; then
  APK_PATHS=(
    "build/app/outputs/flutter-apk/app-production-release.apk"
    "build/app/outputs/apk/production/release/app-production-release.apk"
    "build/app/outputs/flutter-apk/app-staging-release.apk"
    "build/app/outputs/apk/staging/release/app-staging-release.apk"
    "build/app/outputs/flutter-apk/app-dev-release.apk"
    "build/app/outputs/apk/dev/release/app-dev-release.apk"
    "build/app/outputs/flutter-apk/app-release.apk"
    "build/app/outputs/apk/release/app-release.apk"
  )
  AAB_PATHS=(
    "build/app/outputs/bundle/productionRelease/app-production-release.aab"
    "build/app/outputs/bundle/release/app-production-release.aab"
    "build/app/outputs/bundle/stagingRelease/app-staging-release.aab"
    "build/app/outputs/bundle/release/app-staging-release.aab"
    "build/app/outputs/bundle/devRelease/app-dev-release.aab"
    "build/app/outputs/bundle/release/app-dev-release.aab"
    "build/app/outputs/bundle/release/app-release.aab"
  )
else
  APK_PATHS=(
    "build/app/outputs/flutter-apk/app-dev-debug.apk"
    "build/app/outputs/apk/dev/debug/app-dev-debug.apk"
    "build/app/outputs/flutter-apk/app-staging-debug.apk"
    "build/app/outputs/apk/staging/debug/app-staging-debug.apk"
    "build/app/outputs/flutter-apk/app-production-debug.apk"
    "build/app/outputs/apk/production/debug/app-production-debug.apk"
    "build/app/outputs/flutter-apk/app-debug.apk"
    "build/app/outputs/apk/debug/app-debug.apk"
    "build/app/outputs/apk/app-debug.apk"
  )
  AAB_PATHS=(
    "build/app/outputs/bundle/devDebug/app-dev-debug.aab"
    "build/app/outputs/bundle/debug/app-dev-debug.aab"
    "build/app/outputs/bundle/stagingDebug/app-staging-debug.aab"
    "build/app/outputs/bundle/debug/app-staging-debug.aab"
    "build/app/outputs/bundle/productionDebug/app-production-debug.aab"
    "build/app/outputs/bundle/debug/app-production-debug.aab"
    "build/app/outputs/bundle/debug/app-debug.aab"
    "build/app/outputs/bundle/app-debug.aab"
  )
fi

# Search for APK
APK_FOUND=""
for apk_path in "${APK_PATHS[@]}"; do
  if [ -f "$apk_path" ]; then
    APK_SIZE=$(du -h "$apk_path" | cut -f1)
    echo "✅ APK found: $(basename "$apk_path") (${APK_SIZE}) at $apk_path"
    APK_FOUND="$apk_path"
    break
  fi
done

if [ -z "$APK_FOUND" ]; then
  echo "❌ APK not found in any expected location!"
  echo "📁 Checking all available APK files..."
  find build -name "*.apk" 2>/dev/null | head -20 || echo "No APK files found anywhere"
  echo "📁 Listing build/app/outputs structure:"
  find build/app/outputs -type f 2>/dev/null | head -20 || echo "build/app/outputs not found"
  exit 1
fi

# Search for AAB
AAB_FOUND=""
for aab_path in "${AAB_PATHS[@]}"; do
  if [ -f "$aab_path" ]; then
    AAB_SIZE=$(du -h "$aab_path" | cut -f1)
    echo "✅ AAB found: $(basename "$aab_path") (${AAB_SIZE}) at $aab_path"
    AAB_FOUND="$aab_path"
    break
  fi
done

if [ -z "$AAB_FOUND" ]; then
  echo "❌ AAB not found in any expected location!"
  echo "📁 Checking all available AAB files..."
  find build -name "*.aab" 2>/dev/null | head -20 || echo "No AAB files found anywhere"
  echo "📁 Listing build/app/outputs/bundle structure:"
  find build/app/outputs/bundle -type f 2>/dev/null | head -20 || echo "build/app/outputs/bundle not found"
  exit 1
fi

echo "🎉 All artifacts verified successfully!"
echo "📦 APK: $APK_FOUND"
echo "📦 AAB: $AAB_FOUND"
