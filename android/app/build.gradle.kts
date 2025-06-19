import java.util.Properties
import java.io.FileInputStream
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.mini_coding_challenges"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Enable BuildConfig feature for custom build configuration fields
    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.example.mini_coding_challenges"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Support for CI/CD injected signing
            if (project.hasProperty("android.injected.signing.store.file")) {
                storeFile = file(project.property("android.injected.signing.store.file") as String)
                storePassword = project.property("android.injected.signing.store.password") as String
                keyAlias = project.property("android.injected.signing.key.alias") as String
                keyPassword = project.property("android.injected.signing.key.password") as String
            } else if (keystorePropertiesFile.exists()) {
                // Use local keystore properties
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { File(it.toString()) }
                storePassword = keystoreProperties["storePassword"] as String?
            } else if (file("keystore.jks").exists()) {
                // Fallback to local keystore.jks
                storeFile = file("keystore.jks")
            }
        }
    }

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

flutter {
    source = "../.."
}
