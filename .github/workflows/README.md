# 🚀 Flutter Build Workflows Documentation

This document describes the GitHub Actions workflows set up for building the Mini Coding Challenges Flutter app with different flavors.

## 📋 Overview

The project has **three separate workflows** for building different flavors of the app:

| Workflow | Flavor | Default Build Type | Branches | Description |
|----------|--------|-------------------|----------|-------------|
| `dev-build.yml` | **dev** | `debug` | `main`, `develop`, `feature/*` | Development builds |
| `staging-build.yml` | **staging** | `debug` | `staging`, `develop` | Staging builds |
| `production-build.yml` | **production** | `release` | `main`, `master` | Production builds |

## 🎯 Workflow Details

### 1. Dev Build Workflow (`dev-build.yml`)
- **Flavor**: `dev`
- **Target File**: `lib/main_dev.dart`
- **Package ID**: `com.example.mini_coding_challenges.dev`
- **App Name**: "Mini Challenges (Dev)"
- **Default Build Type**: `debug`
- **Triggers**: Push/PR to `main`, `develop`, `feature/*` branches
- **Fastlane Lanes**: `build_debug_artifacts`, `build_release_artifacts`

### 2. Staging Build Workflow (`staging-build.yml`)
- **Flavor**: `staging`
- **Target File**: `lib/main_staging.dart`
- **Package ID**: `com.example.mini_coding_challenges.staging`
- **App Name**: "Mini Challenges (Staging)"
- **Default Build Type**: `debug`
- **Triggers**: Push/PR to `staging`, `develop` branches
- **Fastlane Lanes**: `build_staging_debug_artifacts`, `build_staging_release_artifacts`

### 3. Production Build Workflow (`production-build.yml`)
- **Flavor**: `production`
- **Target File**: `lib/main_production.dart`
- **Package ID**: `com.example.mini_coding_challenges`
- **App Name**: "Mini Coding Challenges"
- **Default Build Type**: `release`
- **Triggers**: Push/PR to `main`, `master` branches
- **Fastlane Lanes**: `build_production_debug_artifacts`, `build_production_release_artifacts`

## 🔧 Workflow Features

All workflows include the following features:

### ✅ Dynamic Versioning
- Timestamp-based version codes
- Git commit-based version names
- Configurable version suffixes

### ✅ Comprehensive Artifact Verification
- Checks multiple possible APK locations:
  - `build/app/outputs/flutter-apk/app-{flavor}-{type}.apk`
  - `build/app/outputs/apk/{flavor}/{type}/app-{flavor}-{type}.apk`
  - Fallback to standard locations
- Checks multiple possible AAB locations:
  - `build/app/outputs/bundle/{flavor}{Type}/app-{flavor}-{type}.aab`
  - `build/app/outputs/bundle/{type}/app-{flavor}-{type}.aab`
  - Fallback to standard locations

### ✅ Flexible Build Types
- Manual workflow dispatch with build type selection (`debug` or `release`)
- Automatic build type based on workflow defaults
- Support for custom version suffixes

### ✅ Artifact Management
- Automatic artifact upload with flavor-specific naming
- Build metadata generation (JSON)
- Different retention periods per flavor:
  - **Dev**: 30 days
  - **Staging**: 30 days
  - **Production**: 90 days (APK/AAB), 180 days (build info)

### ✅ Build Summary
- Comprehensive build information in GitHub Actions summary
- Flavor-specific artifact listings
- Git and version information

## 🏗️ Fastlane Integration

Each workflow uses flavor-specific Fastlane lanes:

### Dev Flavor Lanes
```ruby
build_debug_artifacts      # Dev debug build
build_release_artifacts    # Dev release build (uses production flavor for backward compatibility)
```

### Staging Flavor Lanes
```ruby
build_staging_debug_artifacts    # Staging debug build
build_staging_release_artifacts  # Staging release build
```

### Production Flavor Lanes
```ruby
build_production_debug_artifacts    # Production debug build
build_production_release_artifacts  # Production release build
```

## 📦 Artifact Naming Convention

Artifacts are named with the following pattern:
- **APK**: `{flavor}-apk-{build_type}-{version_name}`
- **AAB**: `{flavor}-aab-{build_type}-{version_name}`
- **Build Info**: `{flavor}-build-info-{version_name}`

Example:
- `dev-apk-debug-1.0.0-debug-a1b2c3d`
- `staging-aab-release-1.0.0-staging-a1b2c3d`
- `production-apk-release-1.0.0`

## 🚀 Usage

### Manual Trigger
1. Go to **Actions** tab in GitHub
2. Select the desired workflow (`Dev Build`, `Staging Build`, or `Production Build`)
3. Click **Run workflow**
4. Select build type (`debug` or `release`)
5. Optionally add version suffix
6. Click **Run workflow**

### Automatic Trigger
Workflows trigger automatically based on branch pushes:
- **Dev**: Any push to `main`, `develop`, or `feature/*`
- **Staging**: Push to `staging` or `develop`
- **Production**: Push to `main` or `master`

## 🛠️ Artifact Locations

Each flavor produces artifacts in specific locations:

### Dev Flavor
```
build/app/outputs/flutter-apk/app-dev-debug.apk
build/app/outputs/apk/dev/debug/app-dev-debug.apk
build/app/outputs/bundle/devDebug/app-dev-debug.aab
```

### Staging Flavor
```
build/app/outputs/flutter-apk/app-staging-debug.apk
build/app/outputs/apk/staging/debug/app-staging-debug.apk
build/app/outputs/bundle/stagingDebug/app-staging-debug.aab
```

### Production Flavor
```
build/app/outputs/flutter-apk/app-production-release.apk
build/app/outputs/apk/production/release/app-production-release.apk
build/app/outputs/bundle/productionRelease/app-production-release.aab
```

## 🔍 Troubleshooting

If artifact verification fails, the workflows will:
1. List all available APK/AAB files
2. Show the build output directory structure
3. Provide detailed error messages
4. Exit with error code 1

Check the workflow logs for detailed debugging information including:
- Expected artifact paths
- Actual file locations
- Directory listings
- File sizes and timestamps

## 📝 Notes

- All workflows use the same Flutter setup and dependencies
- Java 17 is used for Android builds
- Ruby 3.2 is used for Fastlane
- Artifacts are automatically cleaned up based on retention policies
- Build metadata includes comprehensive git and environment information
