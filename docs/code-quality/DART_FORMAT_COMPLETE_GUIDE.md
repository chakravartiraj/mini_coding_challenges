# Dart Format CLI Command - Complete Guide

## Overview

The `dart format` command is a powerful code formatting tool that ensures consistent code style across Dart and Flutter projects. This guide covers usage patterns from junior developers to senior professionals, with practical examples and best practices.

## Table of Contents

- [Basic Usage (Junior Level)](#basic-usage-junior-level)
- [Intermediate Usage (Mid-Level)](#intermediate-usage-mid-level)  
- [Advanced Usage (Senior Level)](#advanced-usage-senior-level)
- [CI/CD Integration](#cicd-integration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Basic Usage (Junior Level)

### 1. Simple Formatting
**Purpose**: Format your code to follow Dart style guidelines
```bash
# Format current directory and subdirectories
dart format .

# Format specific file
dart format lib/main.dart

# Format specific directory
dart format lib/
```

**What it does**:
- Automatically fixes indentation (2 spaces)
- Adjusts line breaks and spacing
- Ensures consistent bracket placement
- Follows Dart style guide conventions

**Example output**:
```
Formatted lib/main.dart
Formatted lib/features/auth/login.dart
Formatted 15 files (2 changed) in 0.8 seconds
```

### 2. Check Mode (Don't Change Files)
**Purpose**: See what would be formatted without making changes
```bash
# Check if files need formatting
dart format --output=none .

# Check specific file
dart format --output=none lib/main.dart
```

**When to use**:
- Before committing code
- In pre-commit hooks
- To verify code style compliance

### 3. Basic File Selection
```bash
# Format all Dart files in lib/
dart format lib/

# Format multiple specific files
dart format lib/main.dart lib/app.dart

# Format with wildcards (in shells that support it)
dart format lib/**/*.dart
```

---

## Intermediate Usage (Mid-Level)

### 4. Output Control Options
**Purpose**: Control where formatted code goes

```bash
# Don't write changes, just check (exit code 1 if changes needed)
dart format --output=none .

# Write to stdout instead of modifying files
dart format --output=show lib/main.dart

# Write changes back to files (default behavior)
dart format --output=write .
```

**Professional applications**:
- IDE integration
- Custom tooling development
- Automated formatting pipelines

### 5. Exit Code Control
**Purpose**: Use in scripts and automation

```bash
# Exit with code 1 if any files need formatting
dart format --set-exit-if-changed .

# Combine with output=none for CI/CD checks
dart format --output=none --set-exit-if-changed .
```

**Script example**:
```bash
#!/bin/bash
if ! dart format --output=none --set-exit-if-changed .; then
    echo "❌ Code formatting issues found. Run 'dart format .' to fix."
    exit 1
fi
echo "✅ Code formatting is correct."
```

### 6. Line Length Control
**Purpose**: Customize line length limits

```bash
# Default line length (80 characters)
dart format .

# Custom line length
dart format --line-length=120 .

# Common line lengths used in teams
dart format --line-length=100 .  # Wider screens
dart format --line-length=120 .  # Modern preference
```

**Team considerations**:
- **80 characters**: Traditional, good for side-by-side viewing
- **100 characters**: Balanced approach
- **120 characters**: Modern wide-screen preference

### 7. Exclude Patterns
**Purpose**: Skip formatting for specific files

```bash
# Using .gitignore-style patterns
dart format --exclude="**/*.g.dart" .

# Multiple exclusions
dart format --exclude="**/*.g.dart" --exclude="**/*.freezed.dart" .

# Exclude generated files (common pattern)
dart format --exclude="**/*.{g,freezed,config,gr}.dart" .
```

---

## Advanced Usage (Senior Level)

### 8. Integration with Version Control
**Purpose**: Format only changed files for efficiency

```bash
# Format only files modified in last commit
git diff --name-only HEAD~1 | grep '\.dart$' | xargs dart format

# Format only staged files
git diff --cached --name-only | grep '\.dart$' | xargs dart format

# Format files in current branch vs main
git diff main --name-only | grep '\.dart$' | xargs dart format
```

### 9. Advanced Scripting and Automation
**Purpose**: Complex formatting workflows

```bash
# Format with error handling
dart format . 2>&1 | tee format_output.log

# Format and count changes
echo "Files formatted: $(dart format . | grep -c 'Formatted')"

# Conditional formatting based on file age
find lib -name "*.dart" -mtime -1 -exec dart format {} \;
```

### 10. Performance Optimization
**Purpose**: Optimize formatting for large projects

```bash
# Format in parallel (using GNU parallel)
find lib -name "*.dart" | parallel -j 4 dart format

# Format specific subdirectories independently
dart format lib/core/ & \
dart format lib/features/ & \
dart format lib/shared/ & \
wait

# Time the formatting operation
time dart format .
```

### 11. Custom Formatting Workflows
**Purpose**: Advanced team workflows

```bash
# Format with validation
format_and_validate() {
    dart format .
    if ! dart analyze --fatal-infos; then
        echo "Formatting caused analysis issues"
        git checkout -- .
        exit 1
    fi
}

# Format with backup
backup_and_format() {
    git stash push -m "Pre-format backup"
    dart format .
    echo "Backup created in stash"
}
```

### 12. Integration with Build Systems
**Purpose**: Integrate with complex build processes

```bash
# Melos workspace formatting (multi-package)
melos exec -- dart format .

# Integration with Mason (code generation)
mason make feature --name=auth && dart format lib/features/auth/

# Format after code generation
dart run build_runner build && dart format .
```

---

## CI/CD Integration

### 13. GitHub Actions Integration

```yaml
name: Code Formatting Check
on: [push, pull_request]

jobs:
  format-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1
      - name: Check formatting
        run: dart format --output=none --set-exit-if-changed .
```

### 14. Pre-commit Hooks

```bash
#!/bin/sh
# .git/hooks/pre-commit

echo "🎨 Checking Dart code formatting..."

# Check if formatting is needed
if ! dart format --output=none --set-exit-if-changed .; then
    echo "❌ Code formatting issues found."
    echo "🔧 Auto-formatting your code..."
    dart format .
    echo "✅ Code formatted. Please review and commit again."
    exit 1
fi

echo "✅ Code formatting is correct."
```

### 15. GitLab CI Integration

```yaml
format_check:
  image: dart:stable
  stage: test
  script:
    - dart format --output=none --set-exit-if-changed .
  only:
    - merge_requests
    - main
```

### 16. Jenkins Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Format Check') {
            steps {
                sh 'dart format --output=none --set-exit-if-changed .'
            }
        }
    }
}
```

---

## Troubleshooting

### 17. Common Issues and Solutions

#### Formatting Hangs or Takes Too Long
```bash
# Check what files are being processed
dart format --verbose .

# Format smaller chunks
dart format lib/core/
dart format lib/features/
dart format lib/shared/

# Exclude problematic files
dart format --exclude="**/large_generated_file.dart" .
```

#### Inconsistent Formatting Results
```bash
# Ensure consistent Dart SDK version
dart --version

# Check for hidden characters or encoding issues
file lib/main.dart
hexdump -C lib/main.dart | head

# Force UTF-8 encoding
iconv -f UTF-8 -t UTF-8 lib/main.dart > temp && mv temp lib/main.dart
```

#### Formatting Conflicts with IDE
```bash
# Check IDE settings vs dart format settings
dart format --line-length=80 .  # Match IDE setting

# Generate IDE-compatible format
dart format --output=show lib/main.dart > formatted_main.dart
```

#### Permission Issues
```bash
# Check file permissions
ls -la lib/main.dart

# Fix permissions if needed
chmod 644 lib/main.dart
dart format lib/main.dart
```

---

## Best Practices

### 18. Development Workflow Integration

#### Individual Developer Workflow
```bash
# 1. Before starting work
dart format .

# 2. Before each commit
git add .
dart format --output=none --set-exit-if-changed .

# 3. After resolving merge conflicts
git merge main
dart format .
```

#### Team Workflow Standards
```bash
# Team standard script (.scripts/format.sh)
#!/bin/bash
echo "🎨 Formatting Dart code..."
dart format --line-length=120 .
echo "✅ Formatting complete"

# Make executable
chmod +x .scripts/format.sh

# Team usage
./.scripts/format.sh
```

### 19. IDE Integration Settings

#### VS Code Settings
```json
{
  "dart.lineLength": 120,
  "editor.formatOnSave": true,
  "editor.formatOnType": true,
  "dart.enableSdkFormatter": true
}
```

#### IntelliJ/Android Studio
```
File → Settings → Languages & Frameworks → Dart
☑ Use the 'dart format' tool when formatting the whole file
Line length: 120
```

### 20. Project-Specific Configuration

#### Analysis Options Integration
```yaml
# analysis_options.yaml
linter:
  rules:
    # Ensure formatting rules align
    lines_longer_than_80_chars: false  # When using --line-length=120
    prefer_single_quotes: true
    curly_braces_in_flow_control_structures: true
```

#### Team Documentation
```markdown
# Code Style Guide

## Formatting Standards
- **Line length**: 120 characters
- **Indentation**: 2 spaces (automatic)
- **Quotes**: Single quotes preferred
- **Trailing commas**: Required for multi-line constructs

## Commands
```bash
# Format code before committing
dart format --line-length=120 .

# Check formatting in CI
dart format --output=none --set-exit-if-changed .
```

### 21. Performance Optimization for Large Projects

```bash
# Optimize for large codebases
optimize_format() {
    # Only format modified files
    if git diff --quiet HEAD~1; then
        echo "No changes to format"
        return 0
    fi
    
    # Format only changed files
    git diff --name-only HEAD~1 | \
        grep '\.dart$' | \
        head -50 | \
        xargs -r dart format
    
    echo "Formatted $(git diff --name-only HEAD~1 | grep -c '\.dart$') files"
}

# Use in CI for faster builds
optimize_format
```

---

## Command Reference Quick Guide

### Essential Commands (All Levels)

| Command | Purpose | Use Case |
|---------|---------|----------|
| `dart format .` | Format all files | Daily development |
| `dart format --output=none .` | Check without changing | Pre-commit checks |
| `dart format --set-exit-if-changed .` | Check with exit code | CI/CD pipelines |
| `dart format --line-length=120 .` | Custom line length | Team standards |
| `dart format --exclude="**/*.g.dart" .` | Skip generated files | Clean formatting |

### Advanced Commands (Senior Level)

| Command | Purpose | Use Case |
|---------|---------|----------|
| `git diff --name-only \| grep '\.dart$' \| xargs dart format` | Format changed files | Efficient workflows |
| `dart format --verbose .` | Debug formatting | Troubleshooting |
| `find lib -name "*.dart" -mtime -1 -exec dart format {} \;` | Format recent files | Maintenance scripts |
| `melos exec -- dart format .` | Multi-package format | Monorepo management |

---

## Performance Tips

### For Small Projects (Junior Level)
1. **Use basic commands**: `dart format .` is sufficient
2. **Format frequently**: After each feature or bug fix
3. **Check before commits**: Use `--output=none` to verify

### For Medium Projects (Mid-Level)
1. **Use exclusions**: Skip generated files with `--exclude`
2. **Integrate with IDE**: Enable format-on-save
3. **Automate checks**: Set up pre-commit hooks

### For Large Projects (Senior Level)
1. **Format incrementally**: Only changed files in CI
2. **Use parallel processing**: Format different modules simultaneously
3. **Optimize workflows**: Combine with other tools efficiently
4. **Monitor performance**: Track formatting time and optimize

This comprehensive guide provides Dart developers at all levels with the knowledge to effectively use `dart format` for maintaining consistent code style throughout their development workflow.
