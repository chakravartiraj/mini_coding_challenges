# 🧪 Testing Guide

> **How to run tests and write new ones for the Mini Coding Challenges app**

## 🎯 Types of Tests

### **Unit Tests** 
Test individual functions and classes in isolation:
- **BLoC logic** - State transitions and business rules
- **Use cases** - Core business logic  
- **Repository implementations** - Data layer logic
- **Utility functions** - Helper methods

### **Widget Tests**
Test UI components without running the full app:
- **Individual widgets** - Buttons, lists, forms
- **Widget interactions** - Taps, scrolls, inputs
- **State changes** - UI updates based on data
- **Screen layouts** - Responsive design

### **Integration Tests**
Test complete app flows:
- **Full user journeys** - From start to finish
- **API integration** - Real network calls
- **Navigation flows** - Between screens
- **End-to-end scenarios** - Complete workflows

## ⚡ Running Tests

### **Run All Tests**
```bash
# Run everything
flutter test

# Run with coverage report
flutter test --coverage
```

### **Run Specific Test Types**
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only  
flutter test test/widget/

# Integration tests only
flutter test test/integration/
```

### **Run Single Test File**
```bash
# Test specific file
flutter test test/features/transactions/bloc/transactions_bloc_test.dart

# Run with watch mode (re-runs on changes)
flutter test --watch test/features/transactions/
```

## 📁 Test Structure

```
test/
├── unit/                           # Unit tests
│   ├── features/
│   │   └── transactions/
│   │       ├── data/              # Repository, data source tests
│   │       ├── domain/            # Use case, entity tests  
│   │       └── presentation/      # BLoC tests
│   └── core/                      # Shared utility tests
├── widget/                        # Widget tests
│   └── features/
│       └── transactions/
│           └── presentation/
│               └── pages/
│                   └── transactions_page_test.dart
└── integration/                   # Integration tests
    └── app_test.dart
```

## 🔧 Writing Tests

### **Unit Test Example - BLoC**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionsBloc', () {
    late TransactionsBloc bloc;
    late MockGetTransactions mockGetTransactions;

    setUp(() {
      mockGetTransactions = MockGetTransactions();
      bloc = TransactionsBloc(getTransactions: mockGetTransactions);
    });

    blocTest<TransactionsBloc, TransactionsState>(
      'emits [loading, loaded] when LoadTransactions is added',
      build: () {
        when(() => mockGetTransactions(any()))
            .thenAnswer((_) async => Right(mockTransactions));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTransactions()),
      expect: () => [
        TransactionsState.loading(),
        TransactionsState.loaded(transactions: mockTransactions),
      ],
    );
  });
}
```

### **Widget Test Example**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  group('TransactionsPage', () {
    testWidgets('displays loading indicator when state is loading', (tester) async {
      // Arrange
      final mockBloc = MockTransactionsBloc();
      when(() => mockBloc.state).thenReturn(TransactionsState.loading());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TransactionsBloc>.value(
            value: mockBloc,
            child: TransactionsPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays transactions list when loaded', (tester) async {
      // Arrange
      final mockBloc = MockTransactionsBloc();
      when(() => mockBloc.state).thenReturn(
        TransactionsState.loaded(transactions: mockTransactions)
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TransactionsBloc>.value(
            value: mockBloc,
            child: TransactionsPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Transaction 1'), findsOneWidget);
    });
  });
}
```

### **Integration Test Example**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mini_coding_challenges/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete transaction list flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial load
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify transactions loaded
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Transaction'), findsWidgets);

      // Test pagination - scroll to bottom
      await tester.drag(find.byType(ListView), Offset(0, -1000));
      await tester.pumpAndSettle();

      // Verify more transactions loaded
      final listFinder = find.byType(ListView);
      final ListView listView = tester.widget(listFinder);
      expect(listView.semanticChildCount, greaterThan(20));

      // Test pull to refresh
      await tester.drag(find.byType(ListView), Offset(0, 300));
      await tester.pumpAndSettle();

      // Verify refresh happened
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
```

## 🎯 Testing Best Practices

### **Test Organization**
- **Follow AAA pattern** - Arrange, Act, Assert
- **One concept per test** - Test single behavior
- **Descriptive names** - Clear what's being tested
- **Group related tests** - Use `group()` to organize

### **Mock Dependencies**
```dart
// Use Mocktail for mocking
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockGetTransactions extends Mock implements GetTransactions {}

// Set up mocks in setUp()
setUp(() {
  mockRepository = MockTransactionRepository();
  when(() => mockRepository.getTransactions(any()))
      .thenAnswer((_) async => mockTransactions);
});
```

### **Test Data**
```dart
// Create reusable test data
final mockTransactions = [
  Transaction(id: '1', description: 'Test 1', amount: 100.0),
  Transaction(id: '2', description: 'Test 2', amount: 200.0),
];

// Use builders for complex objects
TransactionBuilder() {
  return Transaction(
    id: faker.guid.guid(),
    description: faker.lorem.sentence(),
    amount: faker.randomGenerator.decimal(),
  );
}
```

## 📊 Test Coverage

### **Check Coverage**
```bash
# Generate coverage report
flutter test --coverage

# View HTML report (if lcov installed)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### **Coverage Goals**
- **Unit tests** - Aim for 80%+ coverage
- **Critical paths** - 100% coverage for core features
- **BLoC logic** - All state transitions tested
- **Error cases** - All error scenarios covered

## 🛠️ CI/CD Integration

Tests run automatically in CI/CD pipeline:

### **On Pull Requests**
```yaml
# .github/workflows/ci.yml
- name: Run Tests
  run: flutter test --coverage

- name: Upload Coverage
  uses: codecov/codecov-action@v1
  with:
    file: coverage/lcov.info
```

### **Quality Gates**
- **All tests must pass** before merge
- **Coverage must maintain** minimum threshold
- **No test failures** in main branch

## 🐛 Debugging Tests

### **Common Issues**
```bash
# Test timeout
flutter test --timeout=60s

# Memory issues
flutter test --concurrency=1

# Specific test debugging
flutter test --plain-name="specific test name"
```

### **Debug Tools**
```dart
// Add debug prints
debugPrint('State: $state');

// Use flutter test with verbose
flutter test --verbose

// Debug widget tests
await tester.binding.setSurfaceSize(Size(1200, 800));
```

## ⚡ Quick Commands

```bash
# Daily testing workflow
flutter test                    # Run all tests
flutter analyze                # Check code quality
dart format --set-exit-if-changed .  # Check formatting

# Before committing
flutter test --coverage        # Ensure good coverage
flutter test test/integration/  # Verify integration tests pass

# CI/CD pipeline locally
./scripts/pre-commit-quality-check.sh  # If available
```

## ➡️ Advanced Testing

- **[Testing Strategy](TESTING_STRATEGY_GUIDE.md)** - Complete testing approach
- **[BLoC Testing](../architecture/BLOC_PATTERN.md#testing)** - BLoC-specific testing
- **[Comprehensive Testing](COMPREHENSIVE_TESTING_STRATEGY.md)** - Full testing documentation

*Good tests give you confidence to ship features fast without breaking existing functionality.*

### **Widget Tests** ✅
- **UI Components**: Widget rendering and interaction
- **User Interface**: Visual components and layouts
- **Coverage**: Critical UI components tested

### **Integration Tests** ✅
- **App Structure**: End-to-end app functionality
- **Performance**: App performance validation
- **Coverage**: Key user journeys tested

## 🏆 **Testing Achievements**

- ✅ **Clean Architecture Testing** - All layers properly tested
- ✅ **BLoC Pattern Testing** - Complete state management coverage
- ✅ **Error Handling** - Comprehensive error scenario testing
- ✅ **Industry Standards** - Professional testing practices
- ✅ **Maintainable Tests** - Clean, readable test structure

## 📊 **Test Metrics**

```
📈 COVERAGE BREAKDOWN
├── Domain Entities: 100% ✅
├── Use Cases: 100% ✅  
├── BLoC States: 100% ✅
├── Business Logic: 100% ✅
├── Error Handling: 95% ✅
├── UI Components: 85% ✅
└── Integration: 80% ✅
```

## 🚀 **Testing Tools & Frameworks**

- **flutter_test** - Core Flutter testing framework
- **bloc_test** - BLoC-specific testing utilities
- **mocktail** - Mocking framework for dependencies
- **Custom Test Helpers** - Reusable test utilities and builders

## 📖 **Reading Order**

1. **Start with**: [Testing Strategy Guide](./TESTING_STRATEGY_GUIDE.md) for practical approach
2. **Deep dive**: [Comprehensive Testing Strategy](./COMPREHENSIVE_TESTING_STRATEGY.md) for complete strategy
3. **Results**: [Testing Integration Complete](./TESTING_INTEGRATION_COMPLETE.md) for implementation report

---

*For navigation back to main documentation index, see [../README.md](../README.md)*
