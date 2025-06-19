# Contributing to Mini Coding Challenges

Thank you for your interest in contributing to Mini Coding Challenges! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our commitment to creating a welcoming and inclusive environment. Please be respectful and constructive in all interactions.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Git
- Your favorite IDE (VS Code, Android Studio, or IntelliJ)

### Setup

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/mini-coding-challenges-flutter.git
   cd mini-coding-challenges-flutter
   ```

3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/mini-coding-challenges-flutter.git
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Run code generation**:
   ```bash
   flutter packages pub run build_runner build
   ```

## 🔄 Development Workflow

### Branching Strategy

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/feature-name` - Individual feature development
- `bugfix/bug-description` - Bug fixes
- `hotfix/critical-fix` - Critical production fixes

### Working on Features

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Keep your branch updated**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

3. **Make your changes** following our coding standards

4. **Test your changes**:
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

## 📏 Coding Standards

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` to format your code
- Follow the existing project structure and naming conventions

### Architecture Guidelines

- **Clean Architecture**: Maintain separation between domain, data, and presentation layers
- **BLoC Pattern**: Use BLoC for state management
- **Dependency Injection**: Use GetIt for dependency management
- **Single Responsibility**: Each class should have one reason to change

### File Organization

```
lib/
├── core/                    # Core functionality
├── features/               # Feature-based modules
│   └── feature_name/
│       ├── data/          # Data layer
│       ├── domain/        # Domain layer
│       └── presentation/  # Presentation layer
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `kConstantName`
- **Private members**: `_privateMember`

## 🧪 Testing Requirements

### Test Coverage

All contributions must maintain or improve test coverage:

- **Unit Tests**: Required for all business logic
- **Widget Tests**: Required for custom widgets
- **Integration Tests**: Required for feature flows

### Running Tests

```bash
# All tests
flutter test

# Specific test categories
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/

# With coverage
flutter test --coverage
```

### Test Guidelines

- **Arrange-Act-Assert** pattern
- **Descriptive test names** that explain the scenario
- **Mock external dependencies** using Mocktail
- **Test edge cases** and error scenarios
- **Use test builders** from `test/helpers/` for consistency

## 📝 Pull Request Process

### Before Submitting

1. **Ensure all tests pass**:
   ```bash
   flutter test
   ```

2. **Run static analysis**:
   ```bash
   flutter analyze
   ```

3. **Format your code**:
   ```bash
   dart format .
   ```

4. **Update documentation** if needed

### PR Requirements

- **Clear title** and description
- **Reference related issues** (e.g., "Fixes #123")
- **Include test coverage** for new features
- **Screenshots** for UI changes
- **Breaking changes** clearly documented

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Tests pass locally
- [ ] Documentation updated
```

## 🏷️ Commit Message Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```bash
feat(transactions): add pagination support
fix(bloc): resolve state emission issue
docs(readme): update installation instructions
test(domain): add entity validation tests
```

## 🐛 Reporting Issues

### Bug Reports

Include:
- Flutter/Dart version
- Device/OS information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/error logs

### Feature Requests

Include:
- Clear description of the feature
- Use case/motivation
- Proposed implementation approach
- Examples from other apps/libraries

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## 🤝 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Code Review**: All PRs receive thorough review and feedback

## 🎉 Recognition

Contributors will be acknowledged in:
- README contributors section
- Release notes
- GitHub contributors graph

Thank you for contributing to Mini Coding Challenges! 🚀
