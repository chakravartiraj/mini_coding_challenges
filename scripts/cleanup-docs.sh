#!/bin/bash

# Documentation Cleanup Script
# Moves duplicate/redundant documentation to legacy folder for archival

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
LEGACY_DIR="$DOCS_DIR/legacy"

echo "🧹 Documentation Cleanup - Moving Redundant Files to Legacy"
echo "Project Root: $PROJECT_ROOT"
echo "Creating legacy directory..."

# Create legacy directory structure
mkdir -p "$LEGACY_DIR"/{android,ci-cd,testing,architecture,deployment,root-summaries}

echo "📁 Moving duplicate Android documentation..."
# Android duplicates (content merged into build/ANDROID_SIGNING.md)
for file in \
    "android/ANDROID_COMPLETE_SIGNING_GUIDE.md" \
    "android/ANDROID_KEYSTORE_COMPLETE_GUIDE.md" \
    "android/ANDROID_KEYSTORE_GUIDE.md" \
    "android/ANDROID_KEYSTORE_SUCCESS_SUMMARY.md" \
    "android/ANDROID_SIGNING_SETUP.md" \
    "android/ANDROID_SIGNING_SUCCESS.md"
do
    if [ -f "$DOCS_DIR/$file" ]; then
        echo "  Moving $file"
        mv "$DOCS_DIR/$file" "$LEGACY_DIR/android/"
    fi
done

echo "🚀 Moving duplicate CI/CD documentation..."
# CI/CD implementation notes (historical)
for file in \
    "ci-cd/CI_CD_IMPLEMENTATION_SUMMARY.md" \
    "ci-cd/CI_CD_PERFORMANCE_OPTIMIZATION_GUIDE.md" \
    "ci-cd/CI_CD_PIPELINE_DOCUMENTATION.md" \
    "ci-cd/CI_CD_QUICK_SETUP_GUIDE.md" \
    "ci-cd/PIPELINE_IMPLEMENTATION.md" \
    "ci-cd/SETUP_GUIDE.md"
do
    if [ -f "$DOCS_DIR/$file" ]; then
        echo "  Moving $file"
        mv "$DOCS_DIR/$file" "$LEGACY_DIR/ci-cd/"
    fi
done

echo "🧪 Moving duplicate Testing documentation..."
# Testing strategy docs (consolidated)
for file in \
    "testing/COMPREHENSIVE_TESTING_STRATEGY.md" \
    "testing/TESTING_INTEGRATION_COMPLETE.md" \
    "testing/TESTING_STRATEGY_GUIDE.md"
do
    if [ -f "$DOCS_DIR/$file" ]; then
        echo "  Moving $file"
        mv "$DOCS_DIR/$file" "$LEGACY_DIR/testing/"
    fi
done

echo "🏗️ Moving duplicate Architecture documentation..."
# Architecture duplicates (simplified)
for file in \
    "architecture/COMPLETE_IMPLEMENTATION_GUIDE.md" \
    "architecture/IMPLEMENTATION_GUIDE.md" \
    "architecture/SUMMARY.md"
do
    if [ -f "$DOCS_DIR/$file" ]; then
        echo "  Moving $file"
        mv "$DOCS_DIR/$file" "$LEGACY_DIR/architecture/"
    fi
done

echo "🚀 Moving duplicate Deployment documentation..."
# Deployment duplicates (unified)
for file in \
    "deployment/FASTLANE_COMPLETE_DOCUMENTATION.md" \
    "deployment/FASTLANE_INTEGRATION_COMPLETE_SUMMARY.md" \
    "deployment/FASTLANE_INTEGRATION_STATUS.md" \
    "deployment/FASTLANE_INTEGRATION_VERIFICATION.md"
do
    if [ -f "$DOCS_DIR/$file" ]; then
        echo "  Moving $file"
        mv "$DOCS_DIR/$file" "$LEGACY_DIR/deployment/"
    fi
done

echo "📋 Moving root level summaries..."
# Root level summaries (redundant)
for file in \
    "DEBUG_BUILD_ERROR_ANALYSIS.md" \
    "DEBUG_BUILD_IMPLEMENTATION_SUMMARY.md" \
    "BUILD_RELEASE_SCRIPT_SUMMARY.md" \
    "DOCUMENTATION_NORMALIZATION_SUMMARY.md"
do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        echo "  Moving $file"
        mv "$PROJECT_ROOT/$file" "$LEGACY_DIR/root-summaries/"
    fi
done

# Create legacy README
cat > "$LEGACY_DIR/README.md" << 'EOF'
# 📚 Legacy Documentation

This folder contains historical documentation that has been consolidated or superseded by the normalized documentation structure.

## 🎯 Why These Files Are Here

During documentation normalization (applying SOLID, YAGNI, KISS, and Feynman principles), we:
- **Merged duplicate guides** - Multiple files covering same topics
- **Simplified complex documentation** - Removed unnecessary complexity  
- **Eliminated redundancy** - Single source of truth for each topic
- **Improved onboarding** - Junior developer friendly language

## 📁 Contents

### **android/** - Historical Android signing guides
Content merged into: **[../build/ANDROID_SIGNING.md](../build/ANDROID_SIGNING.md)**

### **ci-cd/** - Implementation summaries and historical CI/CD docs  
Content unified into: **[../ci-cd/README.md](../ci-cd/README.md)**

### **testing/** - Comprehensive testing strategy documents
Content simplified into: **[../testing/README.md](../testing/README.md)**

### **architecture/** - Detailed implementation guides
Content streamlined into: **[../architecture/README.md](../architecture/README.md)**

### **deployment/** - Fastlane integration documentation
Content consolidated into: **[../deployment/README.md](../deployment/README.md)**

### **root-summaries/** - Various project summaries
Information integrated into main documentation

## 🧭 Finding Current Documentation

**For current documentation, see:**
- **[Main Documentation Hub](../README.md)** - Project overview and navigation
- **[Quick Start](../QUICK_START.md)** - 5-minute setup guide  
- **[Documentation Index](../DOCUMENTATION_INDEX.md)** - Complete documentation map

## 📜 Historical Reference

These files are kept for:
- **Historical reference** - Understanding project evolution
- **Implementation details** - Technical details not in current docs
- **Audit trail** - What was built and why
- **Transition period** - Ensuring no information was lost

*For current development, use the main documentation. These files are for reference only.*
EOF

echo "📝 Creating legacy directory index..."

echo "✅ Documentation cleanup complete!"
echo ""
echo "📊 Summary:"
echo "  - Moved duplicate files to docs/legacy/"
echo "  - Organized by category (android, ci-cd, testing, etc.)"
echo "  - Created legacy README with navigation"
echo "  - Preserved all content for historical reference"
echo ""
echo "📖 Current documentation structure:"
echo "  docs/"
echo "  ├── README.md              # Main hub"
echo "  ├── QUICK_START.md         # 5-minute onboarding"  
echo "  ├── setup/README.md        # Environment setup"
echo "  ├── build/                 # Build guides"
echo "  ├── architecture/README.md # Project structure"
echo "  ├── testing/README.md      # Testing guide"
echo "  ├── ci-cd/README.md        # CI/CD pipeline"
echo "  ├── deployment/README.md   # Release process"
echo "  ├── troubleshooting/README.md # Problem solving"
echo "  └── legacy/                # Historical docs"
echo ""
echo "🎉 Documentation is now normalized and ready for use!"
