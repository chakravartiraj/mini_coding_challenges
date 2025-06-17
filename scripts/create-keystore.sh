#!/bin/bash

# 🔐 Interactive Keystore Creation Script
# Creates Android keystores with proper validation and error handling

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Clear screen and show header
clear
echo -e "${PURPLE}🔐 Interactive Android Keystore Creation Script${NC}"
echo -e "${CYAN}=================================================${NC}"
echo ""
echo -e "${YELLOW}This script will guide you through creating a secure Android keystore${NC}"
echo -e "${YELLOW}for signing your Flutter applications.${NC}"
echo ""

# Function to validate input
validate_not_empty() {
    local input="$1"
    local field_name="$2"
    
    if [[ -z "$input" ]]; then
        echo -e "${RED}❌ Error: $field_name cannot be empty!${NC}"
        return 1
    fi
    return 0
}

# Function to validate password strength
validate_password() {
    local password="$1"
    
    if [[ ${#password} -lt 8 ]]; then
        echo -e "${RED}❌ Password must be at least 8 characters long${NC}"
        return 1
    fi
    
    if [[ ! "$password" =~ [A-Z] ]]; then
        echo -e "${YELLOW}⚠️  Warning: Password should contain uppercase letters${NC}"
    fi
    
    if [[ ! "$password" =~ [0-9] ]]; then
        echo -e "${YELLOW}⚠️  Warning: Password should contain numbers${NC}"
    fi
    
    if [[ ! "$password" =~ [^a-zA-Z0-9] ]]; then
        echo -e "${YELLOW}⚠️  Warning: Password should contain special characters${NC}"
    fi
    
    return 0
}

# Function to check if keytool is available
check_keytool() {
    if ! command -v keytool &> /dev/null; then
        echo -e "${RED}❌ Error: keytool not found!${NC}"
        echo -e "${YELLOW}Please install Java JDK or Android Studio${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ keytool found${NC}"
}

# Function to create keystores directory
setup_keystore_directory() {
    KEYSTORE_DIR="$HOME/keystores"
    
    if [[ ! -d "$KEYSTORE_DIR" ]]; then
        echo -e "${BLUE}📁 Creating keystores directory: $KEYSTORE_DIR${NC}"
        mkdir -p "$KEYSTORE_DIR"
    else
        echo -e "${GREEN}✅ Keystores directory exists: $KEYSTORE_DIR${NC}"
    fi
    
    echo ""
}

# Function to get user input with validation
get_input() {
    local prompt="$1"
    local var_name="$2"
    local is_password="$3"
    local default_value="$4"
    local input=""
    
    while true; do
        if [[ "$is_password" == "true" ]]; then
            echo -ne "${CYAN}$prompt${NC}"
            read -s input
            echo ""
        else
            if [[ -n "$default_value" ]]; then
                echo -ne "${CYAN}$prompt [$default_value]: ${NC}"
            else
                echo -ne "${CYAN}$prompt: ${NC}"
            fi
            read input
        fi
        
        # Use default if empty and default provided
        if [[ -z "$input" && -n "$default_value" ]]; then
            input="$default_value"
        fi
        
        if validate_not_empty "$input" "$var_name"; then
            if [[ "$is_password" == "true" ]]; then
                if validate_password "$input"; then
                    break
                fi
            else
                break
            fi
        fi
        echo ""
    done
    
    echo "$input"
}

# Function to confirm password
confirm_password() {
    local original_password="$1"
    local confirm_password=""
    
    echo -ne "${CYAN}Confirm password: ${NC}"
    read -s confirm_password
    echo ""
    
    if [[ "$original_password" != "$confirm_password" ]]; then
        echo -e "${RED}❌ Passwords don't match!${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Passwords match${NC}"
    return 0
}

# Function to display summary
show_summary() {
    echo ""
    echo -e "${PURPLE}📋 Keystore Creation Summary${NC}"
    echo -e "${CYAN}=============================${NC}"
    echo -e "${YELLOW}Project Name:${NC} $PROJECT_NAME"
    echo -e "${YELLOW}Keystore File:${NC} $KEYSTORE_FILE"
    echo -e "${YELLOW}Key Alias:${NC} $KEY_ALIAS"
    echo -e "${YELLOW}Organization:${NC} $ORGANIZATION"
    echo -e "${YELLOW}Location:${NC} $CITY, $STATE, $COUNTRY"
    echo -e "${YELLOW}Validity:${NC} 10,000 days (~27 years)"
    echo ""
}

# Function to create keystore
create_keystore() {
    echo -e "${BLUE}🔨 Creating keystore...${NC}"
    echo ""
    
    # Build the keytool command
    local keytool_cmd="keytool -genkey -v"
    keytool_cmd+=" -keystore '$KEYSTORE_DIR/$KEYSTORE_FILE'"
    keytool_cmd+=" -keyalg RSA"
    keytool_cmd+=" -keysize 2048"
    keytool_cmd+=" -validity 10000"
    keytool_cmd+=" -alias '$KEY_ALIAS'"
    keytool_cmd+=" -storepass '$STORE_PASSWORD'"
    keytool_cmd+=" -keypass '$KEY_PASSWORD'"
    keytool_cmd+=" -dname 'CN=$ORGANIZATION, OU=$ORGANIZATIONAL_UNIT, O=$ORGANIZATION, L=$CITY, ST=$STATE, C=$COUNTRY'"
    
    # Execute the command
    if eval "$keytool_cmd"; then
        echo ""
        echo -e "${GREEN}✅ Keystore created successfully!${NC}"
        return 0
    else
        echo ""
        echo -e "${RED}❌ Failed to create keystore!${NC}"
        return 1
    fi
}

# Function to verify keystore
verify_keystore() {
    echo -e "${BLUE}🔍 Verifying keystore...${NC}"
    
    if keytool -list -keystore "$KEYSTORE_DIR/$KEYSTORE_FILE" -alias "$KEY_ALIAS" -storepass "$STORE_PASSWORD" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Keystore verification successful!${NC}"
        
        # Show keystore details
        echo ""
        echo -e "${CYAN}📋 Keystore Details:${NC}"
        keytool -list -v -keystore "$KEYSTORE_DIR/$KEYSTORE_FILE" -alias "$KEY_ALIAS" -storepass "$STORE_PASSWORD" | grep -E "(Alias name|Creation date|Owner|SHA256)"
        
        return 0
    else
        echo -e "${RED}❌ Keystore verification failed!${NC}"
        return 1
    fi
}

# Function to create key.properties template
create_key_properties_template() {
    local template_file="$KEYSTORE_DIR/key.properties.template"
    
    echo -e "${BLUE}📄 Creating key.properties template...${NC}"
    
    cat > "$template_file" << EOF
# Android Keystore Configuration
# Copy this file to your Flutter project's android/ directory
# and rename it to key.properties

storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_DIR/$KEYSTORE_FILE
EOF
    
    echo -e "${GREEN}✅ Template created: $template_file${NC}"
    
    # Create project-specific key.properties if in Flutter project
    if [[ -d "android" && -f "pubspec.yaml" ]]; then
        echo -e "${BLUE}📄 Creating project key.properties...${NC}"
        cp "$template_file" "android/key.properties"
        echo -e "${GREEN}✅ Project key.properties created: android/key.properties${NC}"
    fi
}

# Function to show next steps
show_next_steps() {
    echo ""
    echo -e "${PURPLE}🚀 Next Steps${NC}"
    echo -e "${CYAN}============${NC}"
    echo ""
    echo -e "${YELLOW}1. Security:${NC}"
    echo -e "   • Backup your keystore file securely"
    echo -e "   • Store passwords in a secure password manager"
    echo -e "   • Never commit keystore or passwords to version control"
    echo ""
    echo -e "${YELLOW}2. Flutter Project Setup:${NC}"
    echo -e "   • Copy android/key.properties to your Flutter project"
    echo -e "   • Update build.gradle.kts with signing configuration"
    echo -e "   • Test with: ${CYAN}flutter build apk --release${NC}"
    echo ""
    echo -e "${YELLOW}3. Verification:${NC}"
    echo -e "   • Use verification script: ${CYAN}./scripts/verify-builds.sh${NC}"
    echo -e "   • Check signature: ${CYAN}keytool -printcert -jarfile app-release.apk${NC}"
    echo ""
    echo -e "${YELLOW}4. Reuse for Multiple Projects:${NC}"
    echo -e "   • Use the same keystore with different aliases"
    echo -e "   • Copy key.properties template and update alias"
    echo ""
}

# Main execution starts here
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
check_keytool
setup_keystore_directory

echo -e "${CYAN}Please provide the following information:${NC}"
echo ""

# Get project information
PROJECT_NAME=$(get_input "Project name (e.g., 'My Awesome App')" "Project name" false)
KEYSTORE_FILE=$(get_input "Keystore filename" "Keystore filename" false "$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')-keystore.jks")
KEY_ALIAS=$(get_input "Key alias" "Key alias" false "$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')")

echo ""
echo -e "${CYAN}Organization Information:${NC}"
ORGANIZATION=$(get_input "Organization/Company name" "Organization" false "$PROJECT_NAME Development")
ORGANIZATIONAL_UNIT=$(get_input "Organizational Unit" "Organizational Unit" false "Development Team")
CITY=$(get_input "City" "City" false "Development City")
STATE=$(get_input "State/Province" "State" false "Development State")
COUNTRY=$(get_input "Country code (2 letters, e.g., US, UK, IN)" "Country" false "US")

echo ""
echo -e "${CYAN}Password Configuration:${NC}"
echo -e "${YELLOW}Note: Use strong passwords with uppercase, numbers, and special characters${NC}"

while true; do
    STORE_PASSWORD=$(get_input "Keystore password (min 8 chars)" "Keystore password" true)
    echo ""
    if confirm_password "$STORE_PASSWORD"; then
        break
    fi
    echo ""
done

echo ""
echo -e "${CYAN}Do you want to use the same password for the key? [Y/n]: ${NC}"
read use_same_password

if [[ "$use_same_password" =~ ^[Nn]$ ]]; then
    echo ""
    while true; do
        KEY_PASSWORD=$(get_input "Key password (min 8 chars)" "Key password" true)
        echo ""
        if confirm_password "$KEY_PASSWORD"; then
            break
        fi
        echo ""
    done
else
    KEY_PASSWORD="$STORE_PASSWORD"
    echo -e "${GREEN}✅ Using same password for key${NC}"
fi

# Show summary and confirm
show_summary

echo -e "${CYAN}Do you want to create this keystore? [Y/n]: ${NC}"
read confirm_creation

if [[ "$confirm_creation" =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}⏹️  Keystore creation cancelled${NC}"
    exit 0
fi

# Create keystore
echo ""
if create_keystore && verify_keystore; then
    echo ""
    create_key_properties_template
    show_next_steps
    
    echo ""
    echo -e "${GREEN}🎉 Keystore creation completed successfully!${NC}"
    echo -e "${CYAN}Keystore location: $KEYSTORE_DIR/$KEYSTORE_FILE${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Keystore creation failed!${NC}"
    echo -e "${YELLOW}Please check the error messages above and try again${NC}"
    exit 1
fi
