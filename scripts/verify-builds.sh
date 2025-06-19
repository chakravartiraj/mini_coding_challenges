#!/bin/bash

echo "🔍 Mini Coding Challenges - Build Verification Script"
echo "===================================================="
echo "📋 Verifies all APK and AAB builds (debug & release) in outputs/"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

KEYSTORE_PATH="$HOME/keystores/krupto-keystore.jks"
KEYSTORE_ALIAS="krupto"
STORE_PASS="ApoCryPhal!3"
OUTPUTS_DIR="build/app/outputs"

# Function to format file size
format_size() {
    local size_bytes=$1
    if [ $size_bytes -gt 1073741824 ]; then
        echo "$(( size_bytes / 1073741824 ))GB"
    elif [ $size_bytes -gt 1048576 ]; then
        echo "$(( size_bytes / 1048576 ))MB"
    elif [ $size_bytes -gt 1024 ]; then
        echo "$(( size_bytes / 1024 ))KB"
    else
        echo "${size_bytes}B"
    fi
}

# Function to get file timestamp
get_file_timestamp() {
    local file=$1
    if [ -f "$file" ]; then
        stat -c %y "$file" 2>/dev/null | cut -d'.' -f1 || echo "Unknown"
    else
        echo "N/A"
    fi
}

# Function to check signature details (enhanced for both debug and release)
check_signature_details() {
    local file=$1
    local file_type=$2
    
    # Try to get actual signature information with timeout for performance
    if timeout 3 keytool -printcert -jarfile "$file" &>/dev/null; then
        # Get actual certificate details
        local cert_info=$(timeout 3 keytool -printcert -jarfile "$file" 2>/dev/null)
        local owner=$(echo "$cert_info" | grep -E "(Owner|Subject)" | head -1 | sed 's/.*: //')
        
        echo -e "    🔐 Signed: ${GREEN}Yes${NC}"
        
        # Check if it's a debug signature by examining the certificate
        if echo "$owner" | grep -qi "android debug\|CN=Android Debug"; then
            echo -e "    ${YELLOW}🛠️  Debug signature (Android Debug)${NC}"
            return 1 # Debug signature
        else
            echo -e "    ${GREEN}🚀 Release signature${NC}"
            echo -e "    📄 Subject: ${owner}"
            return 0 # Release signature
        fi
    else
        # Fallback to filename-based detection if certificate check fails/times out
        if echo "$file" | grep -qi "debug"; then
            echo -e "    ${YELLOW}🛠️  Debug build (filename-based)${NC}"
            return 1 # Debug build
        elif echo "$file" | grep -qi "release"; then
            echo -e "    ${GREEN}🚀 Release build (filename-based)${NC}"
            return 0 # Release build
        else
            echo -e "    ${RED}❌ Unsigned or unknown signature${NC}"
            return 2 # Unknown signature
        fi
    fi
}

# Function to check all APK files
check_all_apks() {
    echo -e "${BLUE}📱 Checking All APK Files in ${OUTPUTS_DIR}/...${NC}"
    echo ""
    
    # Find all APK files in outputs directory
    local apk_files=($(find "$OUTPUTS_DIR" -name "*.apk" 2>/dev/null | sort))
    local debug_count=0
    local release_count=0
    local unsigned_count=0
    
    if [ ${#apk_files[@]} -eq 0 ]; then
        echo -e "${RED}❌ No APK files found in ${OUTPUTS_DIR}/${NC}"
        echo -e "${YELLOW}💡 Run: flutter build apk --debug (debug) or flutter build apk --release (release)${NC}"
        echo ""
        return
    fi
    
    echo -e "${GREEN}✅ Found ${#apk_files[@]} APK file(s):${NC}"
    echo ""
    
    for apk in "${apk_files[@]}"; do
        if [ -f "$apk" ]; then
            local size=$(stat -c%s "$apk" 2>/dev/null || echo "0")
            local formatted_size=$(format_size $size)
            local timestamp=$(get_file_timestamp "$apk")
            local relative_path=$(echo "$apk" | sed "s|^$OUTPUTS_DIR/||")
            
            echo -e "  📱 ${CYAN}${relative_path}${NC}"
            echo -e "    📏 Size: ${formatted_size}"
            echo -e "    🕒 Created: ${timestamp}"
            
            # Check signature and categorize
            check_signature_details "$apk" "APK"
            local sig_result=$?
            case $sig_result in
                0) ((release_count++)) ;;
                1) ((debug_count++)) ;;
                2) ((unsigned_count++)) ;;
            esac
            
            echo ""
        fi
    done
    
    echo -e "${BLUE}📊 APK Summary:${NC}"
    echo -e "  📱 Total APKs: ${#apk_files[@]}"
    echo -e "  🚀 Release builds: ${release_count}"
    echo -e "  🛠️  Debug builds: ${debug_count}"
    echo -e "  ❌ Unsigned/Unknown: ${unsigned_count}"
    echo ""
}

# Function to check all AAB files
check_all_aabs() {
    echo -e "${BLUE}📦 Checking All AAB Files in ${OUTPUTS_DIR}/...${NC}"
    echo ""
    
    # Find all AAB files in outputs directory
    local aab_files=($(find "$OUTPUTS_DIR" -name "*.aab" 2>/dev/null | sort))
    local debug_count=0
    local release_count=0
    local unsigned_count=0
    
    if [ ${#aab_files[@]} -eq 0 ]; then
        echo -e "${RED}❌ No AAB files found in ${OUTPUTS_DIR}/${NC}"
        echo -e "${YELLOW}💡 Run: flutter build appbundle --debug (debug) or flutter build appbundle --release (release)${NC}"
        echo ""
        return
    fi
    
    echo -e "${GREEN}✅ Found ${#aab_files[@]} AAB file(s):${NC}"
    echo ""
    
    for aab in "${aab_files[@]}"; do
        if [ -f "$aab" ]; then
            local size=$(stat -c%s "$aab" 2>/dev/null || echo "0")
            local formatted_size=$(format_size $size)
            local timestamp=$(get_file_timestamp "$aab")
            local relative_path=$(echo "$aab" | sed "s|^$OUTPUTS_DIR/||")
            
            echo -e "  📦 ${CYAN}${relative_path}${NC}"
            echo -e "    📏 Size: ${formatted_size}"
            echo -e "    🕒 Created: ${timestamp}"
            
            # Check signature and categorize
            check_signature_details "$aab" "AAB"
            local sig_result=$?
            case $sig_result in
                0) ((release_count++)) ;;
                1) ((debug_count++)) ;;
                2) ((unsigned_count++)) ;;
            esac
            
            echo ""
        fi
    done
    
    echo -e "${BLUE}📊 AAB Summary:${NC}"
    echo -e "  📦 Total AABs: ${#aab_files[@]}"
    echo -e "  🚀 Release builds: ${release_count}"
    echo -e "  🛠️  Debug builds: ${debug_count}"
    echo -e "  ❌ Unsigned/Unknown: ${unsigned_count}"
    echo ""
}

# Function to show keystore info
show_keystore() {
    echo -e "${BLUE}🔑 Keystore Information:${NC}"
    if [ -f "$KEYSTORE_PATH" ]; then
        local size=$(stat -c%s "$KEYSTORE_PATH" 2>/dev/null || echo "0")
        local formatted_size=$(format_size $size)
        echo -e "${GREEN}✅ Keystore exists: ${KEYSTORE_PATH} (${formatted_size})${NC}"
        echo "🔍 Keystore Certificate: (Skipped for performance)"
    else
        echo -e "${RED}❌ Keystore not found at $KEYSTORE_PATH${NC}"
        echo -e "${YELLOW}💡 Check if keystore path is correct in android/key.properties${NC}"
    fi
    echo ""
}

# Function to check build info files
check_build_info() {
    echo -e "${BLUE}📄 Checking Build Information Files:${NC}"
    
    local info_files=("build_info.json" "build_metadata.json")
    
    for info_file in "${info_files[@]}"; do
        if [ -f "$info_file" ]; then
            echo -e "${GREEN}✅ $info_file found${NC}"
            if command -v jq &> /dev/null; then
                echo "  Content:"
                jq -r '. | "    Version: \(.version_name // "N/A"), Build: \(.version_code // "N/A"), Branch: \(.git_branch // "N/A")"' "$info_file" 2>/dev/null || echo "    (Could not parse JSON)"
            else
                echo "    (Install jq to view formatted content)"
            fi
        else
            echo -e "${YELLOW}⚠️  $info_file not found${NC}"
        fi
    done
    echo ""
}

# Function to show build directory structure
show_build_structure() {
    echo -e "${BLUE}📁 Build Directory Structure:${NC}"
    
    if [ -d "$OUTPUTS_DIR" ]; then
        echo -e "${GREEN}✅ ${OUTPUTS_DIR}/ structure:${NC}"
        find "$OUTPUTS_DIR" -type f \( -name "*.apk" -o -name "*.aab" \) 2>/dev/null | while read file; do
            local size=$(stat -c%s "$file" 2>/dev/null || echo "0")
            local formatted_size=$(format_size $size)
            local relative_path=$(echo "$file" | sed "s|^$OUTPUTS_DIR/||")
            echo "  📂 ${relative_path} (${formatted_size})"
        done
        
        # Show count summary
        local apk_count=$(find "$OUTPUTS_DIR" -name "*.apk" 2>/dev/null | wc -l)
        local aab_count=$(find "$OUTPUTS_DIR" -name "*.aab" 2>/dev/null | wc -l)
        echo -e "${GREEN}📊 Summary: ${apk_count} APK(s), ${aab_count} AAB(s)${NC}"
    else
        echo -e "${RED}❌ ${OUTPUTS_DIR}/ directory not found${NC}"
        echo -e "${YELLOW}💡 Run a build first:${NC}"
        echo -e "   Debug: ./scripts/build-debug-local.sh or flutter build apk --debug${NC}"
        echo -e "   Release: flutter build apk --release${NC}"
    fi
    echo ""
}

# Function to compare signatures with keystore
compare_signatures() {
    echo -e "${BLUE}🔍 Signature Comparison with Keystore:${NC}"
    
    if [ -f "$KEYSTORE_PATH" ]; then
        echo "🔑 Keystore found at: $KEYSTORE_PATH"
        echo "(Signature comparison skipped for performance - use keytool manually if needed)"
        echo ""
        
        # Show instruction for manual verification
        echo "💡 Manual signature verification commands:"
        echo "  keytool -list -v -keystore '$KEYSTORE_PATH' -alias '$KEYSTORE_ALIAS' -storepass '$STORE_PASS'"
        echo "  keytool -printcert -jarfile 'path/to/app.apk'"
    else
        echo -e "${RED}❌ Keystore not found at $KEYSTORE_PATH${NC}"
        echo -e "${YELLOW}💡 Cannot compare signatures without keystore${NC}"
    fi
    echo ""
}

# Function to show overall summary
show_overall_summary() {
    echo -e "${BLUE}📋 Overall Build Summary:${NC}"
    
    # Count all artifacts
    local total_apks=0
    local total_aabs=0
    local total_debug_signed=0
    local total_release_signed=0
    local total_unsigned=0
    
    if [ -d "$OUTPUTS_DIR" ]; then
        total_apks=$(find "$OUTPUTS_DIR" -name "*.apk" 2>/dev/null | wc -l)
        total_aabs=$(find "$OUTPUTS_DIR" -name "*.aab" 2>/dev/null | wc -l)
        
        # Count signatures (simplified check)
        while IFS= read -r -d '' file; do
            if keytool -printcert -jarfile "$file" &>/dev/null; then
                local cert_info=$(keytool -printcert -jarfile "$file" 2>/dev/null)
                local owner=$(echo "$cert_info" | grep -E "(Owner|Subject)" | head -1)
                if echo "$owner" | grep -qi "android debug\|CN=Android Debug"; then
                    ((total_debug_signed++))
                else
                    ((total_release_signed++))
                fi
            else
                ((total_unsigned++))
            fi
        done < <(find "$OUTPUTS_DIR" \( -name "*.apk" -o -name "*.aab" \) -print0 2>/dev/null)
    fi
    
    echo -e "  📊 Total Artifacts: $((total_apks + total_aabs))"
    echo -e "  📱 APK Files: ${total_apks}"
    echo -e "  📦 AAB Files: ${total_aabs}"
    echo -e "  🚀 Release Builds: ${total_release_signed}"
    echo -e "  🛠️  Debug Builds: ${total_debug_signed}"
    echo -e "  ❌ Unsigned/Unknown: ${total_unsigned}"
    echo ""
}

# Main execution
echo ""
show_keystore
check_build_info
show_build_structure
check_all_apks
check_all_aabs
compare_signatures
show_overall_summary

echo "🎉 Verification complete!"
echo ""
echo "📋 Quick Commands:"
echo "  Debug Builds:"
echo "    Local Script:      ./scripts/build-debug-local.sh"
echo "    Flutter APK:       flutter build apk --debug"
echo "    Flutter AAB:       flutter build appbundle --debug"
echo "  Release Builds:"
echo "    Flutter APK:       flutter build apk --release"
echo "    Flutter AAB:       flutter build appbundle --release"
echo "  Verification:"
echo "    Re-run Verification: ./scripts/verify-builds.sh"
echo ""
