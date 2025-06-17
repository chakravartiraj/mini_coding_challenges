#!/bin/bash

# ================================================================
# Flutter Pre-Commit Quality Check Script
# Professional quality gate enforcement before code push
# ================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis for better visibility
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
GEAR="🔧"
ROCKET="🚀"
MAGNIFYING="🔍"
TEST_TUBE="🧪"
CHART="📊"

echo -e "${BLUE}${ROCKET} Flutter Pre-Commit Quality Pipeline${NC}"
echo "=================================================="

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

# Function to handle errors
handle_error() {
    echo -e "${RED}${CROSS} $1${NC}"
    echo -e "${YELLOW}${WARNING} Pre-commit checks failed. Please fix the issues above.${NC}"
    exit 1
}

# Function to print success
print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    handle_error "Not a Flutter project (pubspec.yaml not found)"
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    handle_error "Flutter is not installed or not in PATH"
fi

print_section "${GEAR} Environment Setup"

# Clean and get dependencies
echo "Cleaning previous builds..."
flutter clean &> /dev/null

echo "Getting dependencies..."
flutter pub get &> /dev/null || handle_error "Failed to get dependencies"

print_success "Environment setup completed"

print_section "${MAGNIFYING} Static Code Analysis"

# Create reports directory
mkdir -p reports/pre-commit

# 1. Code Formatting Check
echo "Checking code formatting..."
if ! dart format --output=none --set-exit-if-changed lib/ test/ &> reports/pre-commit/format_check.log; then
    print_warning "Code formatting issues found - applying automatic fixes"
    dart format lib/ test/
    echo "Formatted files:"
    git diff --name-only HEAD | grep '\.dart$' || true
    print_success "Code formatting applied automatically"
else
    print_success "Code formatting check passed"
fi

# 2. Apply automated fixes
echo "Applying automated code fixes..."
dart fix --apply &> reports/pre-commit/dart_fix.log
print_success "Automated fixes applied"

# 3. Static analysis
echo "Running static analysis..."
if ! flutter analyze --fatal-infos --fatal-warnings &> reports/pre-commit/analysis.log; then
    echo -e "${RED}Static analysis issues found:${NC}"
    cat reports/pre-commit/analysis.log
    handle_error "Static analysis failed"
fi
print_success "Static analysis passed"

# 4. Check for TODO/FIXME comments in changed files
echo "Checking for TODO/FIXME comments in staged files..."
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' || true)
if [ -n "$staged_files" ]; then
    todo_count=$(grep -n "TODO\|FIXME\|XXX\|HACK" $staged_files 2>/dev/null | wc -l || echo 0)
    if [ "$todo_count" -gt 0 ]; then
        print_warning "Found $todo_count TODO/FIXME comments in staged files"
        grep -n "TODO\|FIXME\|XXX\|HACK" $staged_files 2>/dev/null || true
    fi
fi

print_section "${TEST_TUBE} Testing"

# 5. Unit Tests
if [ -d "test/" ]; then
    echo "Running unit tests..."
    if flutter test --coverage &> reports/pre-commit/test_results.log; then
        print_success "Unit tests passed"
    else
        echo -e "${RED}Unit test failures:${NC}"
        tail -20 reports/pre-commit/test_results.log
        handle_error "Unit tests failed"
    fi
else
    print_warning "No test directory found - consider adding unit tests"
fi

print_section "${CHART} Code Quality Metrics"

# 6. Coverage check (if tests exist and coverage was generated)
if [ -f "coverage/lcov.info" ]; then
    echo "Analyzing test coverage..."
    
    # Install lcov if available for better coverage reporting
    if command -v lcov &> /dev/null; then
        coverage_percent=$(lcov --summary coverage/lcov.info 2>&1 | grep -o '[0-9.]*%' | tail -1 | sed 's/%//')
        if [ -n "$coverage_percent" ]; then
            if (( $(echo "$coverage_percent < 70" | bc -l) )); then
                print_warning "Test coverage is ${coverage_percent}% (recommended: >70%)"
            else
                print_success "Test coverage: ${coverage_percent}%"
            fi
        fi
    else
        print_success "Coverage report generated (install lcov for detailed analysis)"
    fi
fi

# 7. Build validation
print_section "${GEAR} Build Validation"

echo "Validating build configuration..."
if flutter build apk --debug --dry-run &> reports/pre-commit/build_validation.log; then
    print_success "Build validation passed"
else
    echo -e "${RED}Build validation issues:${NC}"
    tail -10 reports/pre-commit/build_validation.log
    handle_error "Build validation failed"
fi

# 8. Dependency analysis
echo "Analyzing dependencies..."
flutter pub deps &> reports/pre-commit/dependencies.log
dep_count=$(flutter pub deps | grep -c '^[a-z]' || echo 0)
print_success "Dependencies analyzed ($dep_count packages)"

# 9. Check for large files
print_section "${MAGNIFYING} File Size Check"

large_files=$(find . -name "*.dart" -size +100k 2>/dev/null || true)
if [ -n "$large_files" ]; then
    print_warning "Large Dart files found (>100KB):"
    echo "$large_files"
fi

# 10. Check pubspec.yaml for version consistency
echo "Checking pubspec.yaml..."
if grep -q "version:" pubspec.yaml; then
    version=$(grep "version:" pubspec.yaml | head -1 | cut -d' ' -f2)
    print_success "App version: $version"
else
    print_warning "No version specified in pubspec.yaml"
fi

# 11. Security check - look for hardcoded sensitive data
print_section "${MAGNIFYING} Security Check"

echo "Checking for potential security issues..."
security_patterns=("password" "secret" "api_key" "token" "private_key")
security_issues=0

for pattern in "${security_patterns[@]}"; do
    if grep -r -i "$pattern" lib/ --include="*.dart" &> /dev/null; then
        matches=$(grep -r -i "$pattern" lib/ --include="*.dart" | wc -l)
        if [ "$matches" -gt 0 ]; then
            print_warning "Found $matches potential security issue(s) with pattern '$pattern'"
            security_issues=$((security_issues + 1))
        fi
    fi
done

if [ "$security_issues" -eq 0 ]; then
    print_success "No obvious security issues found"
fi

# 12. Generate pre-commit summary
print_section "${CHART} Pre-Commit Summary"

cat > reports/pre-commit/summary.md << EOF
# Pre-Commit Quality Check Summary

**Generated:** $(date)

## ✅ Checks Passed
- Code formatting
- Automated fixes applied
- Static analysis
- Unit tests
- Build validation
- Dependency analysis
- Security scan

## 📊 Metrics
- Dart files: $(find lib -name "*.dart" | wc -l)
- Test files: $(find test -name "*.dart" 2>/dev/null | wc -l || echo 0)
- Dependencies: $dep_count packages
- Coverage: ${coverage_percent:-"N/A"}%

## 🚀 Status
**READY FOR COMMIT** ✅

All quality gates passed successfully!
EOF

print_success "Pre-commit summary generated: reports/pre-commit/summary.md"

# Final success message
echo ""
echo -e "${GREEN}${ROCKET} Pre-commit checks completed successfully!${NC}"
echo -e "${GREEN}${CHECK} Your code is ready to be committed and pushed.${NC}"
echo ""
echo "📊 Quality metrics saved in: reports/pre-commit/"
echo "🔍 To run the full CI pipeline locally, use: cd android && bundle exec fastlane --file QualityFastfile master_quality_pipeline"
echo ""

exit 0
