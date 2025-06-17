# Flutter Analyze CLI Command - Complete Guide

## Overview

The `flutter analyze` command is a powerful static analysis tool that helps maintain code quality in Flutter projects. This guide covers usage patterns from junior developers to senior professionals, with practical examples and best practices.

## Table of Contents

- [Basic Usage (Junior Level)](#basic-usage-junior-level)
- [Intermediate Usage (Mid-Level)](#intermediate-usage-mid-level)
- [Advanced Usage (Senior Level)](#advanced-usage-senior-level)
- [CI/CD Integration](#cicd-integration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Basic Usage (Junior Level)

### 1. Simple Analysis
**Purpose**: Check for basic errors and warnings
```bash
# Run basic analysis on current project
flutter analyze

# Most common first command for beginners
flutter analyze .
```

**What it does**:
- Scans all Dart files in the project
- Reports errors, warnings, and info messages
- Uses default analysis options

**Example output**:
```
Analyzing myproject...
   info • Missing documentation • lib/main.dart:10:7 • missing_docs
warning • Unused import • lib/utils.dart:3:1 • unused_import
  error • Undefined name 'nonExistentVariable' • lib/main.dart:25:5 • undefined_identifier
```

### 2. Basic Error Checking
**Purpose**: Focus only on errors (ignore warnings and info)
```bash
# Show only errors (most critical issues)
flutter analyze --fatal-warnings
```

**When to use**:
- Before committing code
- Quick error check during development
- When learning Flutter and focusing on major issues

### 3. Quiet Mode
**Purpose**: Minimal output for clean terminal
```bash
# Reduce output noise
flutter analyze --quiet
```

**Benefits**:
- Less overwhelming for beginners
- Focus on critical issues only
- Cleaner CI/CD output

---

## Intermediate Usage (Mid-Level)

### 4. Custom Verbosity Levels
**Purpose**: Control the amount of information displayed

```bash
# Verbose output with detailed information
flutter analyze --verbose

# Show progress during analysis
flutter analyze --progress

# Combine flags for detailed progress tracking
flutter analyze --verbose --progress
```

**Use cases**:
- Debugging analysis issues
- Understanding what files are being analyzed
- Performance troubleshooting

### 5. Specific File/Directory Analysis
**Purpose**: Analyze specific parts of the codebase

```bash
# Analyze specific file
flutter analyze lib/main.dart

# Analyze specific directory
flutter analyze lib/features/

# Analyze multiple specific files
flutter analyze lib/main.dart lib/app.dart

# Analyze with glob patterns
flutter analyze "lib/**/*.dart"
```

**Benefits**:
- Faster feedback during development
- Focus on current work area
- Useful for large codebases

### 6. Output Format Control
**Purpose**: Customize output for different tools and workflows

```bash
# Machine-readable output (JSON-like)
flutter analyze --machine

# Write results to file
flutter analyze > analysis_results.txt 2>&1

# Separate errors and output
flutter analyze 2> errors.txt 1> output.txt
```

**Professional applications**:
- IDE integration
- Custom tooling development
- Automated reporting systems

### 7. Excluding Patterns
**Purpose**: Skip analysis of specific files or patterns

```bash
# Skip generated files (though usually handled automatically)
flutter analyze --exclude "**/*.g.dart"

# Skip test files temporarily
flutter analyze --exclude "test/**"

# Multiple exclusions
flutter analyze --exclude "**/*.g.dart" --exclude "**/*.freezed.dart"
```

---

## Advanced Usage (Senior Level)

### 8. Fatal Level Control
**Purpose**: Fine-tune what constitutes build failure

```bash
# Treat warnings as fatal (fail build on warnings)
flutter analyze --fatal-warnings

# Treat info messages as fatal (strictest mode)
flutter analyze --fatal-infos

# No fatal warnings (only errors fail)
flutter analyze --no-fatal-warnings
```

**Strategic use**:
- **Development**: `--no-fatal-warnings` for faster iteration
- **Pre-commit**: `--fatal-warnings` for quality gates
- **CI/CD**: `--fatal-infos` for maximum quality

### 9. Advanced File Selection
**Purpose**: Sophisticated file targeting for large projects

```bash
# Analyze only changed files (with git)
git diff --name-only HEAD~1 | grep '\.dart$' | xargs flutter analyze

# Analyze files modified in last commit
git diff-tree --no-commit-id --name-only -r HEAD | grep '\.dart$' | xargs flutter analyze

# Analyze files in staging area
git diff --cached --name-only | grep '\.dart$' | xargs flutter analyze
```

### 10. Performance and Debugging Options
**Purpose**: Optimize analysis performance and debug issues

```bash
# Debug analyzer performance
flutter analyze --verbose --time

# Show analyzer version and configuration
flutter analyze --version

# Use specific analysis options file
flutter analyze --options analysis_options_strict.yaml
```

### 11. Watch Mode for Development
**Purpose**: Continuous analysis during development

```bash
# Watch for file changes and re-analyze
# Note: Not built-in, but can be achieved with tools like 'entr'
find . -name "*.dart" | entr -r flutter analyze

# Using inotifywait (Linux/macOS)
while inotifywait -e modify -r lib/; do
  flutter analyze
done
```

---

## CI/CD Integration

### 12. GitHub Actions Example
```yaml
name: Flutter Analysis
on: [push, pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      # Basic analysis
      - name: Run Flutter Analyze
        run: flutter analyze
      
      # Strict analysis for production
      - name: Run Strict Analysis
        run: flutter analyze --fatal-infos
        continue-on-error: false
```

### 13. GitLab CI Example
```yaml
flutter_analyze:
  image: cirrusci/flutter:stable
  stage: test
  script:
    - flutter pub get
    - flutter analyze --fatal-warnings
  artifacts:
    reports:
      junit: analysis_results.xml
  only:
    - merge_requests
    - main
```

### 14. Custom Analysis Scripts
**Purpose**: Sophisticated CI/CD integration

```bash
#!/bin/bash
# analyze_with_reporting.sh

echo "🔍 Starting Flutter Analysis..."

# Run analysis and capture output
if flutter analyze --fatal-warnings > analysis_output.txt 2>&1; then
  echo "✅ Analysis passed!"
  exit 0
else
  echo "❌ Analysis failed!"
  echo "📋 Analysis results:"
  cat analysis_output.txt
  
  # Count different issue types
  errors=$(grep -c "error •" analysis_output.txt || echo "0")
  warnings=$(grep -c "warning •" analysis_output.txt || echo "0")
  infos=$(grep -c "info •" analysis_output.txt || echo "0")
  
  echo "📊 Summary: $errors errors, $warnings warnings, $infos info messages"
  exit 1
fi
```

---

## Troubleshooting

### 15. Common Issues and Solutions

#### Analysis Hangs or Takes Too Long
```bash
# Check what's being analyzed
flutter analyze --verbose --progress

# Exclude problematic directories
flutter analyze --exclude "build/**" --exclude ".dart_tool/**"

# Clear analysis cache
flutter clean
flutter pub get
flutter analyze
```

#### Inconsistent Results
```bash
# Ensure consistent Dart SDK version
flutter --version
dart --version

# Check analysis options file
cat analysis_options.yaml

# Verify project structure
flutter doctor
```

#### Memory Issues with Large Projects
```bash
# Analyze in smaller chunks
flutter analyze lib/features/auth/
flutter analyze lib/features/dashboard/
flutter analyze lib/features/settings/

# Use exclusions to reduce load
flutter analyze --exclude "**/*.g.dart" --exclude "**/*.freezed.dart"
```

---

## Best Practices

### 16. Development Workflow Integration

#### Pre-commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

echo "Running Flutter analysis..."
if ! flutter analyze --fatal-warnings; then
  echo "❌ Flutter analysis failed. Please fix issues before committing."
  exit 1
fi
echo "✅ Flutter analysis passed."
```

#### IDE Integration Settings
```json
// VS Code settings.json
{
  "dart.analysisServerFolding": true,
  "dart.analysisServerArgs": ["--enable-experiment=non-nullable"],
  "dart.showLintNames": true,
  "dart.analysisExcludedFolders": [
    "build/**",
    ".dart_tool/**"
  ]
}
```

### 17. Team Workflow Strategies

#### For Junior Developers
- Start with basic `flutter analyze`
- Use `--no-fatal-warnings` during learning
- Focus on errors first, then warnings
- Regular analysis before each commit

#### For Mid-Level Developers
- Use `--fatal-warnings` for quality control
- Implement file-specific analysis for efficiency
- Integrate with development tools
- Create custom analysis scripts

#### For Senior Developers
- Implement `--fatal-infos` for production code
- Design team-wide analysis strategies
- Optimize CI/CD pipeline integration
- Mentor team on analysis best practices

### 18. Analysis Options Strategy

#### Development Phase
```yaml
# analysis_options_dev.yaml
analyzer:
  errors:
    # Relaxed during development
    missing_required_param: warning
    dead_code: info
```

#### Production Phase
```yaml
# analysis_options_prod.yaml
analyzer:
  errors:
    # Strict for production
    missing_required_param: error
    dead_code: error
```

```bash
# Use different configs
flutter analyze --options analysis_options_dev.yaml    # Development
flutter analyze --options analysis_options_prod.yaml   # Production
```

---

## Command Reference Quick Guide

| Command | Purpose | Developer Level |
|---------|---------|-----------------|
| `flutter analyze` | Basic analysis | Junior |
| `flutter analyze --quiet` | Minimal output | Junior |
| `flutter analyze --fatal-warnings` | Strict warnings | Intermediate |
| `flutter analyze --fatal-infos` | Maximum strictness | Senior |
| `flutter analyze --verbose` | Detailed output | Intermediate |
| `flutter analyze --machine` | Machine-readable | Senior |
| `flutter analyze lib/specific/` | Target analysis | Intermediate |
| `flutter analyze --exclude "pattern"` | Skip files | Senior |

---

## Performance Tips

### For Large Projects (Senior Level)
1. **Use exclusions**: Skip generated files and build artifacts
2. **Parallel analysis**: Analyze different modules separately
3. **Incremental analysis**: Only analyze changed files in CI/CD
4. **Cache optimization**: Proper CI/CD caching strategies
5. **Resource allocation**: Adjust memory limits for analysis server

### Example: Optimized Large Project Analysis
```bash
#!/bin/bash
# Large project analysis strategy

# 1. Quick check (errors only)
flutter analyze --fatal-warnings --quiet lib/core/

# 2. Module-by-module analysis
for module in auth dashboard settings profile; do
  echo "Analyzing $module module..."
  flutter analyze lib/features/$module/
done

# 3. Full analysis (if needed)
flutter analyze --exclude "**/*.g.dart" --exclude "**/*.freezed.dart"
```

This comprehensive guide provides Flutter developers at all levels with the knowledge to effectively use `flutter analyze` for maintaining high code quality throughout their development workflow.
