#!/bin/bash

echo "🔍 Mini Coding Challenges - Build Verification Script"
echo "=================================================="

KEYSTORE_PATH="$HOME/keystores/krupto-keystore.jks"
KEYSTORE_ALIAS="krupto"
STORE_PASS="ApoCryPhal!3"

# Function to check APK
check_apk() {
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    echo "📱 Checking Release APK..."
    
    if [ -f "$APK_PATH" ]; then
        echo "✅ APK exists: $(ls -lh $APK_PATH | awk '{print $5, $9}')"
        echo "🔍 APK Signature:"
        keytool -printcert -jarfile "$APK_PATH" | grep -E "(Owner|SHA256)" | head -2
    else
        echo "❌ APK not found at $APK_PATH"
        echo "💡 Run: flutter build apk --release"
    fi
    echo ""
}

# Function to check App Bundle
check_bundle() {
    BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
    echo "📦 Checking Release App Bundle..."
    
    if [ -f "$BUNDLE_PATH" ]; then
        echo "✅ Bundle exists: $(ls -lh $BUNDLE_PATH | awk '{print $5, $9}')"
        echo "🔍 Bundle Signature:"
        keytool -printcert -jarfile "$BUNDLE_PATH" | grep -E "(Owner|SHA256)" | head -2
    else
        echo "❌ Bundle not found at $BUNDLE_PATH"
        echo "💡 Run: flutter build appbundle --release"
    fi
    echo ""
}

# Function to show keystore info
show_keystore() {
    echo "🔑 Keystore Information:"
    if [ -f "$KEYSTORE_PATH" ]; then
        echo "✅ Keystore exists: $(ls -lh $KEYSTORE_PATH | awk '{print $5, $9}')"
        echo "🔍 Keystore Certificate:"
        keytool -list -v -keystore "$KEYSTORE_PATH" -alias "$KEYSTORE_ALIAS" -storepass "$STORE_PASS" 2>/dev/null | grep -E "(Owner|SHA256)" | head -2
    else
        echo "❌ Keystore not found at $KEYSTORE_PATH"
        echo "💡 Check if keystore path is correct in android/key.properties"
    fi
    echo ""
}

# Function to compare fingerprints
compare_signatures() {
    echo "🔍 Signature Comparison:"
    
    if [ -f "$KEYSTORE_PATH" ]; then
        KEYSTORE_SHA256=$(keytool -list -v -keystore "$KEYSTORE_PATH" -alias "$KEYSTORE_ALIAS" -storepass "$STORE_PASS" 2>/dev/null | grep "SHA256:" | awk '{print $2}')
        echo "Keystore SHA256: $KEYSTORE_SHA256"
        
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        if [ -f "$APK_PATH" ]; then
            APK_SHA256=$(keytool -printcert -jarfile "$APK_PATH" 2>/dev/null | grep "SHA256:" | awk '{print $2}')
            echo "APK SHA256:     $APK_SHA256"
            
            if [ "$KEYSTORE_SHA256" = "$APK_SHA256" ]; then
                echo "✅ APK signature matches keystore!"
            else
                echo "❌ APK signature does NOT match keystore!"
            fi
        fi
        
        BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
        if [ -f "$BUNDLE_PATH" ]; then
            BUNDLE_SHA256=$(keytool -printcert -jarfile "$BUNDLE_PATH" 2>/dev/null | grep "SHA256:" | awk '{print $2}')
            echo "Bundle SHA256:  $BUNDLE_SHA256"
            
            if [ "$KEYSTORE_SHA256" = "$BUNDLE_SHA256" ]; then
                echo "✅ Bundle signature matches keystore!"
            else
                echo "❌ Bundle signature does NOT match keystore!"
            fi
        fi
    fi
    echo ""
}

# Main execution
show_keystore
check_apk
check_bundle
compare_signatures

echo "🎉 Verification complete!"
echo ""
echo "📋 Quick Commands:"
echo "  Build APK:    flutter build apk --release"
echo "  Build Bundle: flutter build appbundle --release"
echo "  Re-run check: ./scripts/verify-builds.sh"
