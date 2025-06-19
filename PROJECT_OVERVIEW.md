# Mini Coding Challenges

A Flutter project showcasing pagination state implementation using BLoC pattern with clean architecture and **professional CI/CD automation**.

## 🎯 Overview

This project demonstrates:
- **BLoC Pattern** for state management
- **Clean Architecture** principles
- **Pagination Implementation** with clean state handling
- **Professional CI/CD Pipeline** with comprehensive testing and quality automation
- **Modern Flutter Development** patterns and best practices

## 🚀 Quick Start

### **Prerequisites**
```bash
flutter --version  # 3.16.9+
java -version      # 17+
```

### **Setup & Run**
```bash
# 1. Clone and setup
git clone <repository-url>
cd mini_coding_challenges
flutter pub get

# 2. Run the app
flutter run

# 3. Run tests
flutter test
```

**That's it!** The app should show a paginated transaction list.

## 🔨 Build & Deploy

### **Debug Builds**
```bash
# Quick debug build
./scripts/build-debug-local.sh

# Or simple Flutter command
flutter run
```

### **Release Builds**
```bash
# Quick release build (requires keystore setup)
./scripts/build-release-local.sh

# Or Flutter command
flutter build apk --release
```

### **CI/CD Pipeline**
Push to GitHub → Automated testing, building, and deployment

## 📚 Documentation

**Start here for comprehensive guides:**

### **Getting Started**
- **[📖 Documentation Hub](docs/DOCUMENTATION_HUB.md)** - Main navigation and overview
- **[⚡ Quick Start](docs/QUICK_START_GUIDE.md)** - 5-minute setup guide
- **[⚙️ Environment Setup](docs/setup/ENVIRONMENT_SETUP_GUIDE.md)** - Complete development setup

### **Building & Testing**
- **[🔨 Build Guide](docs/build/BUILD_PROCESS_OVERVIEW.md)** - Debug and release builds
- **[🧪 Testing Guide](docs/testing/TESTING_GUIDE_OVERVIEW.md)** - Run and write tests
- **[🛠️ Troubleshooting](docs/troubleshooting/TROUBLESHOOTING_GUIDE_COMPLETE.md)** - Fix common problems

### **Understanding the Code**
- **[🏗️ Architecture](docs/architecture/ARCHITECTURE_OVERVIEW_GUIDE.md)** - Project structure and patterns
- **[✨ Features](docs/features/FEATURES_OVERVIEW_GUIDE.md)** - App functionality explained

### **Advanced Topics**
- **[🚀 CI/CD Pipeline](docs/ci-cd/CICD_PIPELINE_OVERVIEW.md)** - Automated testing and deployment
- **[📱 Deployment](docs/deployment/DEPLOYMENT_OVERVIEW_GUIDE.md)** - Release to app stores

**💡 Tip:** All documentation follows simple, junior-developer-friendly language with clear examples.
alias build-debug='cd /path/to/mini_coding_challenges && ./scripts/build-debug-local.sh'
# Then just run: build-debug
```

### **🚀 Build Release Artifacts (Production)**
```bash
# Requires keystore configuration first!
# Method 1: From anywhere
/path/to/mini_coding_challenges/scripts/build-release-local.sh

# Method 2: From project root
cd mini_coding_challenges
./scripts/build-release-local.sh

# Create release alias
alias build-release='cd /path/to/mini_coding_challenges && ./scripts/build-release-local.sh'
# Then just run: build-release
```

### **🔍 Verify Builds**
```bash
# Verify builds
./scripts/verify-builds.sh
```
📖 **[Complete Build Guide](docs/BUILD_SCRIPTS_USAGE_GUIDE.md)** - All methods and troubleshooting

### **🚦 CI/CD Pipeline**
```bash
# 4. Run CI/CD pipeline locally (optional)
./scripts/pre-commit-quality-check.sh
```

### **CI/CD Setup**
For comprehensive CI/CD pipeline setup:
- **[Quick Setup](docs/QUICK_START_GUIDE.md)** - 5-minute setup
- **[Complete CI/CD Guide](docs/CICD_PIPELINE_COMPLETE_GUIDE.md)** - Full documentation
- **[Implementation Summary](docs/PROJECT_IMPLEMENTATION_SUMMARY.md)** - What was built

## 🏗️ Architecture

### Clean Architecture with BLoC Pattern
```
lib/
├── core/                       # Shared utilities
│   ├── di/                     # Dependency Injection
│   ├── network/                # API Client
│   └── error/                  # Error Handling
├── features/
│   └── transactions/           # Feature modules
│       ├── data/               # API & Data Sources
│       ├── domain/             # Business Logic
│       └── presentation/       # UI & BLoC
└── shared/
    └── widgets/                # Reusable UI Components
```

**Key patterns demonstrated:**
- **BLoC State Management** - Predictable state changes
- **Clean Architecture** - Separation of concerns  
- **Dependency Injection** - Testable, loosely coupled code
- **Repository Pattern** - Data access abstraction

## ✨ Key Features

### **Pagination with BLoC**
- **Smart Loading** - Infinite scroll with efficient list rendering
- **State Management** - Loading, success, error, and refresh states
- **User Experience** - Pull-to-refresh and smooth interactions
- **Error Handling** - Retry mechanisms and user-friendly messages

### **Professional Development Practices**
- **Clean Architecture** - Maintainable and testable codebase
- **CI/CD Automation** - Quality gates and automated builds  
- **Comprehensive Testing** - Unit, widget, and integration tests
- **Code Quality** - Linting, formatting, and security scanning

## 🛠️ Technologies & Tools

### **Core Stack**
```yaml
# State Management & Architecture
flutter_bloc: ^8.1.3
get_it: ^7.6.4
freezed: ^2.4.6

# Data & Networking  
retrofit: ^4.0.3
dio: ^5.3.2
json_annotation: ^4.8.1

# Testing
mocktail: ^1.0.0
bloc_test: ^9.1.4
```

### **Development Tools**
- **Build Automation** - Local scripts and Fastlane integration
- **CI/CD Pipeline** - GitHub Actions with comprehensive testing
- **Code Quality** - Static analysis, formatting, and linting
- **Documentation** - Comprehensive guides following KISS principles

## � Getting Started

**New to the project?** Follow this path:
1. **[Quick Start](docs/QUICK_START_GUIDE.md)** - Get running in 5 minutes
2. **[Architecture Overview](docs/architecture/ARCHITECTURE_OVERVIEW_GUIDE.md)** - Understand the code
3. **[Features Guide](docs/features/FEATURES_OVERVIEW_GUIDE.md)** - Learn what the app does
4. **[Build Guide](docs/build/BUILD_PROCESS_OVERVIEW.md)** - Build and deploy

## 🤝 Contributing

We welcome contributions! See our **[Contributing Guidelines](docs/PROJECT_CONTRIBUTING_GUIDELINES.md)** for:
- Development workflow
- Code standards and patterns  
- Testing requirements
- Documentation guidelines

## � License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**💡 This project demonstrates professional Flutter development practices that scale to real-world applications.**
  flutter_bloc: ^8.1.6        # State Management
  dio: ^5.7.0                  # HTTP Client
  retrofit: ^4.4.1             # API Generation
  freezed_annotation: ^2.4.4   # Immutable Classes
  get_it: ^8.0.0              # Dependency Injection
  injectable: ^2.5.0          # DI Code Generation
```

### **Development Tools**
```yaml
dev_dependencies:
  build_runner: ^2.4.13       # Code Generation
  freezed: ^2.5.7             # Data Classes
  json_serializable: ^6.8.0   # JSON Serialization
  bloc_test: ^9.1.7           # BLoC Testing
  mocktail: ^1.0.4            # Mocking
```

## 🎯 Best Practices Demonstrated

1. **State Management**: Proper BLoC implementation with event/state separation
2. **Error Handling**: Comprehensive error states and user feedback
3. **Performance**: Efficient pagination without memory leaks
4. **Code Organization**: Clean architecture with proper folder structure
5. **Type Safety**: Using Freezed and strong typing throughout
6. **Dependency Management**: Proper DI setup with GetIt
7. **Testing**: Unit tests, widget tests, and BLoC tests
8. **CI/CD**: Professional automation with quality gates

---

This project serves as a comprehensive example of implementing pagination in Flutter using modern best practices, clean architecture principles, and professional DevOps automation.
