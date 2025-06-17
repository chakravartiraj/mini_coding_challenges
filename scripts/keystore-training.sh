#!/bin/bash

# 🎓 Android Keystore CLI Training Script
# Interactive training for keystore creation and management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Training variables
TRAINING_DIR="$HOME/keystore-training"
CURRENT_LESSON=1
TOTAL_LESSONS=8

# Clear screen and show header
clear
echo -e "${PURPLE}🎓 Android Keystore CLI Training${NC}"
echo -e "${CYAN}=================================${NC}"
echo ""
echo -e "${YELLOW}This interactive training will teach you Android keystore management${NC}"
echo -e "${YELLOW}through hands-on CLI exercises.${NC}"
echo ""

# Function to wait for user input
wait_for_user() {
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read -r
}

# Function to show lesson header
show_lesson() {
    local lesson_num="$1"
    local lesson_title="$2"
    
    echo ""
    echo -e "${PURPLE}📚 Lesson $lesson_num/$TOTAL_LESSONS: $lesson_title${NC}"
    echo -e "${CYAN}$(printf '=%.0s' {1..50})${NC}"
    echo ""
}

# Function to show command explanation
explain_command() {
    local command="$1"
    local explanation="$2"
    
    echo -e "${BLUE}📝 Command:${NC} ${YELLOW}$command${NC}"
    echo -e "${BLUE}📖 Purpose:${NC} $explanation"
    echo ""
}

# Function to execute and verify command
run_exercise() {
    local command="$1"
    local expected_result="$2"
    local verification_cmd="$3"
    
    echo -e "${GREEN}🔨 Now you try! Run this command:${NC}"
    echo -e "${YELLOW}$command${NC}"
    echo ""
    echo -e "${CYAN}Type the command and press Enter:${NC}"
    
    while true; do
        read -r user_input
        
        if [[ "$user_input" == "$command" ]]; then
            echo -e "${GREEN}✅ Correct! Executing...${NC}"
            eval "$command"
            
            if [[ -n "$verification_cmd" ]]; then
                echo ""
                echo -e "${BLUE}🔍 Verification:${NC}"
                eval "$verification_cmd"
            fi
            break
        else
            echo -e "${RED}❌ Not quite right. Expected:${NC}"
            echo -e "${YELLOW}$command${NC}"
            echo -e "${CYAN}Try again:${NC}"
        fi
    done
    echo ""
}

# Function to setup training environment
setup_training() {
    show_lesson 1 "Setting Up Training Environment"
    
    explain_command "mkdir -p $TRAINING_DIR" "Create a dedicated directory for training exercises"
    
    if [[ ! -d "$TRAINING_DIR" ]]; then
        run_exercise "mkdir -p $TRAINING_DIR" "Directory created" "ls -la $HOME | grep keystore-training"
    else
        echo -e "${GREEN}✅ Training directory already exists${NC}"
        ls -la "$TRAINING_DIR"
    fi
    
    explain_command "cd $TRAINING_DIR" "Navigate to the training directory"
    run_exercise "cd $TRAINING_DIR" "Changed directory" "pwd"
    
    cd "$TRAINING_DIR"
    wait_for_user
}

# Function to check prerequisites
check_prerequisites() {
    show_lesson 2 "Checking Prerequisites"
    
    explain_command "keytool -help" "Verify that keytool is installed and available"
    
    echo -e "${GREEN}🔨 Let's check if keytool is available:${NC}"
    echo -e "${YELLOW}keytool -help | head -5${NC}"
    echo ""
    
    if command -v keytool &> /dev/null; then
        keytool -help | head -5
        echo -e "${GREEN}✅ keytool is available!${NC}"
    else
        echo -e "${RED}❌ keytool not found!${NC}"
        echo -e "${YELLOW}Please install Java JDK or Android Studio${NC}"
        exit 1
    fi
    
    echo ""
    explain_command "java -version" "Check Java version (required for keytool)"
    run_exercise "java -version" "Java version displayed" ""
    
    wait_for_user
}

# Function to teach keystore creation
learn_keystore_creation() {
    show_lesson 3 "Creating Your First Keystore"
    
    echo -e "${BLUE}📖 Learning Objective:${NC} Create a keystore using keytool command"
    echo ""
    
    explain_command "keytool -genkey -v -keystore training-keystore.jks -keyalg RSA -keysize 2048 -validity 365 -alias training-key" "Generate a new keystore with RSA 2048-bit key, valid for 1 year"
    
    echo -e "${YELLOW}⚠️  Note: You'll be prompted for passwords and certificate information${NC}"
    echo -e "${YELLOW}Use simple values for training (e.g., password: training123)${NC}"
    echo ""
    
    local full_command="keytool -genkey -v -keystore training-keystore.jks -keyalg RSA -keysize 2048 -validity 365 -alias training-key"
    
    echo -e "${GREEN}🔨 Execute this command (you'll need to provide information):${NC}"
    echo -e "${YELLOW}$full_command${NC}"
    echo ""
    echo -e "${CYAN}Press Enter when ready, then run the command:${NC}"
    read -r
    
    eval "$full_command"
    
    echo ""
    echo -e "${GREEN}✅ Keystore created successfully!${NC}"
    ls -la training-keystore.jks
    
    wait_for_user
}

# Function to teach keystore inspection
learn_keystore_inspection() {
    show_lesson 4 "Inspecting Keystore Contents"
    
    explain_command "keytool -list -v -keystore training-keystore.jks" "List all entries in the keystore with verbose details"
    
    run_exercise "keytool -list -v -keystore training-keystore.jks" "Keystore contents displayed" ""
    
    echo ""
    explain_command "keytool -list -keystore training-keystore.jks -alias training-key" "Show specific alias information"
    
    run_exercise "keytool -list -keystore training-keystore.jks -alias training-key" "Alias information displayed" ""
    
    wait_for_user
}

# Function to teach certificate fingerprinting
learn_fingerprinting() {
    show_lesson 5 "Certificate Fingerprinting"
    
    echo -e "${BLUE}📖 Learning Objective:${NC} Understand certificate fingerprints for verification"
    echo ""
    
    explain_command "keytool -list -v -keystore training-keystore.jks | grep -A1 -B1 SHA256" "Extract SHA256 fingerprint from keystore"
    
    run_exercise "keytool -list -v -keystore training-keystore.jks | grep -A1 -B1 SHA256" "SHA256 fingerprint displayed" ""
    
    echo ""
    echo -e "${BLUE}📝 Note:${NC} The SHA256 fingerprint uniquely identifies your certificate"
    echo -e "${BLUE}📝 Use:${NC} This fingerprint is used for app verification and Google Play Console"
    
    wait_for_user
}

# Function to teach keystore backup
learn_backup() {
    show_lesson 6 "Keystore Backup and Security"
    
    echo -e "${BLUE}📖 Learning Objective:${NC} Learn proper keystore backup procedures"
    echo ""
    
    explain_command "cp training-keystore.jks training-keystore-backup.jks" "Create a backup copy of the keystore"
    
    run_exercise "cp training-keystore.jks training-keystore-backup.jks" "Backup created" "ls -la *.jks"
    
    echo ""
    explain_command "chmod 600 training-keystore*.jks" "Set secure permissions (read/write for owner only)"
    
    run_exercise "chmod 600 training-keystore*.jks" "Permissions set" "ls -la *.jks"
    
    echo ""
    echo -e "${YELLOW}🔐 Security Best Practices:${NC}"
    echo -e "   • Always backup your keystores"
    echo -e "   • Store backups in secure, encrypted locations"
    echo -e "   • Use strong passwords"
    echo -e "   • Never commit keystores to version control"
    echo -e "   • Set restrictive file permissions"
    
    wait_for_user
}

# Function to teach multiple aliases
learn_multiple_aliases() {
    show_lesson 7 "Managing Multiple Aliases"
    
    echo -e "${BLUE}📖 Learning Objective:${NC} Add multiple keys to the same keystore"
    echo ""
    
    explain_command "keytool -genkey -keystore training-keystore.jks -alias second-key -keyalg RSA -keysize 2048 -validity 365" "Add a second key alias to existing keystore"
    
    echo -e "${GREEN}🔨 Add a second alias to your keystore:${NC}"
    echo -e "${YELLOW}keytool -genkey -keystore training-keystore.jks -alias second-key -keyalg RSA -keysize 2048 -validity 365${NC}"
    echo ""
    echo -e "${CYAN}Press Enter when ready, then run the command:${NC}"
    read -r
    
    keytool -genkey -keystore training-keystore.jks -alias second-key -keyalg RSA -keysize 2048 -validity 365
    
    echo ""
    explain_command "keytool -list -keystore training-keystore.jks" "List all aliases in the keystore"
    
    run_exercise "keytool -list -keystore training-keystore.jks" "All aliases displayed" ""
    
    wait_for_user
}

# Function to teach cleanup
learn_cleanup() {
    show_lesson 8 "Cleanup and Summary"
    
    echo -e "${BLUE}📖 Learning Objective:${NC} Clean up training files and review commands"
    echo ""
    
    explain_command "ls -la *.jks" "List all keystore files created during training"
    
    run_exercise "ls -la *.jks" "Keystore files listed" ""
    
    echo ""
    echo -e "${CYAN}🧹 Clean up training files? [y/N]:${NC}"
    read -r cleanup_choice
    
    if [[ "$cleanup_choice" =~ ^[Yy]$ ]]; then
        explain_command "rm -f *.jks" "Remove all keystore files"
        run_exercise "rm -f *.jks" "Files removed" "ls -la"
        
        echo ""
        explain_command "cd .. && rmdir $TRAINING_DIR" "Remove training directory"
        run_exercise "cd .. && rmdir $TRAINING_DIR" "Directory removed" "ls -la ~ | grep keystore-training || echo 'Directory removed'"
    else
        echo -e "${YELLOW}💾 Training files preserved in $TRAINING_DIR${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Training Complete!${NC}"
    echo ""
    echo -e "${PURPLE}📚 Commands You've Learned:${NC}"
    echo -e "${YELLOW}• keytool -genkey -v -keystore file.jks -keyalg RSA -keysize 2048 -validity 365 -alias alias${NC}"
    echo -e "${YELLOW}• keytool -list -v -keystore file.jks${NC}"
    echo -e "${YELLOW}• keytool -list -keystore file.jks -alias alias${NC}"
    echo -e "${YELLOW}• chmod 600 file.jks${NC}"
    echo -e "${YELLOW}• cp file.jks backup.jks${NC}"
    echo ""
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo -e "   • Practice with the project's interactive script: ${CYAN}./scripts/create-keystore.sh${NC}"
    echo -e "   • Read the complete guide: ${CYAN}docs/setup/ANDROID_KEYSTORE_COMPLETE_GUIDE.md${NC}"
    echo -e "   • Try building a signed APK: ${CYAN}flutter build apk --release${NC}"
}

# Function to show menu
show_menu() {
    echo -e "${CYAN}📚 Choose training mode:${NC}"
    echo -e "${YELLOW}1)${NC} Full Training (all lessons)"
    echo -e "${YELLOW}2)${NC} Quick Review (key commands only)"
    echo -e "${YELLOW}3)${NC} Custom Lesson (choose specific lesson)"
    echo -e "${YELLOW}4)${NC} Exit"
    echo ""
    echo -e "${CYAN}Enter your choice [1-4]:${NC}"
}

# Function for quick review
quick_review() {
    echo ""
    echo -e "${PURPLE}🔄 Quick Review - Essential Keystore Commands${NC}"
    echo -e "${CYAN}=============================================${NC}"
    echo ""
    
    echo -e "${YELLOW}1. Create Keystore:${NC}"
    echo -e "${BLUE}keytool -genkey -v -keystore app.jks -keyalg RSA -keysize 2048 -validity 10000 -alias app${NC}"
    echo ""
    
    echo -e "${YELLOW}2. List Keystore Contents:${NC}"
    echo -e "${BLUE}keytool -list -v -keystore app.jks${NC}"
    echo ""
    
    echo -e "${YELLOW}3. Check Specific Alias:${NC}"
    echo -e "${BLUE}keytool -list -keystore app.jks -alias app${NC}"
    echo ""
    
    echo -e "${YELLOW}4. Extract Certificate Fingerprint:${NC}"
    echo -e "${BLUE}keytool -list -v -keystore app.jks | grep SHA256${NC}"
    echo ""
    
    echo -e "${YELLOW}5. Set Secure Permissions:${NC}"
    echo -e "${BLUE}chmod 600 app.jks${NC}"
    echo ""
    
    echo -e "${YELLOW}6. Create Backup:${NC}"
    echo -e "${BLUE}cp app.jks app-backup.jks${NC}"
    echo ""
}

# Function for custom lesson selection
custom_lesson() {
    echo ""
    echo -e "${CYAN}📚 Available Lessons:${NC}"
    echo -e "${YELLOW}1)${NC} Setting Up Training Environment"
    echo -e "${YELLOW}2)${NC} Checking Prerequisites"
    echo -e "${YELLOW}3)${NC} Creating Your First Keystore"
    echo -e "${YELLOW}4)${NC} Inspecting Keystore Contents"
    echo -e "${YELLOW}5)${NC} Certificate Fingerprinting"
    echo -e "${YELLOW}6)${NC} Keystore Backup and Security"
    echo -e "${YELLOW}7)${NC} Managing Multiple Aliases"
    echo -e "${YELLOW}8)${NC} Cleanup and Summary"
    echo ""
    echo -e "${CYAN}Enter lesson number [1-8]:${NC}"
    
    read -r lesson_choice
    
    case $lesson_choice in
        1) setup_training ;;
        2) check_prerequisites ;;
        3) learn_keystore_creation ;;
        4) learn_keystore_inspection ;;
        5) learn_fingerprinting ;;
        6) learn_backup ;;
        7) learn_multiple_aliases ;;
        8) learn_cleanup ;;
        *) echo -e "${RED}❌ Invalid lesson number${NC}" ;;
    esac
}

# Main execution
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            setup_training
            check_prerequisites
            learn_keystore_creation
            learn_keystore_inspection
            learn_fingerprinting
            learn_backup
            learn_multiple_aliases
            learn_cleanup
            ;;
        2)
            quick_review
            wait_for_user
            ;;
        3)
            custom_lesson
            wait_for_user
            ;;
        4)
            echo -e "${GREEN}👋 Thanks for training! Happy coding!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Please select 1-4.${NC}"
            echo ""
            ;;
    esac
done
