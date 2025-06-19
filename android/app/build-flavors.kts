// Android Product Flavors Configuration (Kotlin DSL)
// ===================================================
// This file contains the Kotlin DSL version of the product flavors configuration
// that has been integrated into the main build.gradle.kts file.
//
// This serves as documentation and reference for the flavor configuration.

/*
The following configuration has been integrated into build.gradle.kts:

android {
    // Product flavors for different environments
    flavorDimensions += "environment"
    
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Mini Challenges (Dev)")
            buildConfigField("String", "API_BASE_URL", "\"https://dev-api.example.com\"")
            buildConfigField("String", "ENVIRONMENT", "\"dev\"")
        }
        
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Mini Challenges (Staging)")
            buildConfigField("String", "API_BASE_URL", "\"https://staging-api.example.com\"")
            buildConfigField("String", "ENVIRONMENT", "\"staging\"")
        }
        
        create("production") {
            dimension = "environment"
            resValue("string", "app_name", "Mini Coding Challenges")
            buildConfigField("String", "API_BASE_URL", "\"https://api.example.com\"")
            buildConfigField("String", "ENVIRONMENT", "\"production\"")
        }
    }

    buildTypes {
        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
        
        release {
            isDebuggable = false
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
*/

// USAGE:
// ======
// With this configuration, you can now build the following variants:
//
// Debug variants:
// - ./gradlew assembleDevDebug       -> com.example.mini_coding_challenges.dev (dev environment, debug)
// - ./gradlew assembleStagingDebug   -> com.example.mini_coding_challenges.staging (staging environment, debug)
// - ./gradlew assembleProductionDebug -> com.example.mini_coding_challenges (production environment, debug)
//
// Release variants:
// - ./gradlew assembleDevRelease       -> com.example.mini_coding_challenges.dev (dev environment, signed)
// - ./gradlew assembleStagingRelease   -> com.example.mini_coding_challenges.staging (staging environment, signed)
// - ./gradlew assembleProductionRelease -> com.example.mini_coding_challenges (production environment, signed)
//
// Bundle variants (for Play Store):
// - ./gradlew bundleDevRelease
// - ./gradlew bundleStagingRelease
// - ./gradlew bundleProductionRelease
//
// Install variants:
// - ./gradlew installDevDebug
// - ./gradlew installStagingDebug
// - ./gradlew installProductionDebug

// FLUTTER INTEGRATION:
// ===================
// You can also use Flutter commands with flavors:
//
// - flutter build apk --flavor dev
// - flutter build apk --flavor staging
// - flutter build apk --flavor production
//
// - flutter build appbundle --flavor dev
// - flutter build appbundle --flavor staging
// - flutter build appbundle --flavor production
//
// - flutter run --flavor dev
// - flutter run --flavor staging
// - flutter run --flavor production

// ENVIRONMENT CONFIGURATION:
// ==========================
// Each flavor provides different configuration:
//
// Dev Environment:
// - App ID: com.example.mini_coding_challenges.dev
// - App Name: "Mini Challenges (Dev)"
// - API URL: https://dev-api.example.com
// - Can be installed alongside other flavors
//
// Staging Environment:
// - App ID: com.example.mini_coding_challenges.staging
// - App Name: "Mini Challenges (Staging)"
// - API URL: https://staging-api.example.com
// - Can be installed alongside other flavors
//
// Production Environment:
// - App ID: com.example.mini_coding_challenges
// - App Name: "Mini Coding Challenges"
// - API URL: https://api.example.com
// - This is the main production app

// ACCESSING CONFIGURATION IN CODE:
// ================================
// In your Dart/Flutter code, you can access the build configuration:
//
// ```dart
// import 'package:flutter/services.dart';
//
// class BuildConfig {
//   static const platform = MethodChannel('build_config');
//   
//   static Future<String> get environment async {
//     return await platform.invokeMethod('getEnvironment');
//   }
//   
//   static Future<String> get apiBaseUrl async {
//     return await platform.invokeMethod('getApiBaseUrl');
//   }
// }
// ```
//
// Or use the dart-define approach with different launch configurations.
