# Mini Coding Challenges

A Flutter project showcasing pagination state implementation using BLoC pattern with clean architecture and comprehensive CI/CD pipelines.

## 🎯 Overview

This project demonstrates how to implement pagination in Flutter using:
- **BLoC Pattern** for state management
- **Clean Architecture** principles
- **Freezed** for immutable data classes
- **Retrofit** for API integration
- **Dependency Injection** with GetIt
- **Industry-Level CI/CD** with GitHub Actions

## 🚀 CI/CD Pipeline Features

### Comprehensive GitHub Actions Workflows

- **🔍 Pull Request Validation**: Fast feedback (3-6 minutes)
  - Code quality checks, static analysis, security scanning
  - Format validation, build verification, PR metrics

- **🚀 Main CI/CD Pipeline**: Full validation (12-18 minutes)  
  - Multi-platform builds (Android, iOS, Web)
  - Comprehensive testing, deployment, release management

- **📊 Performance Monitoring**: Continuous optimization
  - Build time analysis, app size tracking, memory profiling
  - Performance regression detection

### Code Quality Standards
- **200+ Google Flutter Team Linting Rules**
- **Automated Testing**: Unit, Widget, and Integration tests
- **Security Scanning**: Dependency vulnerabilities, SAST
- **Performance Benchmarks**: Build time and app size monitoring

### Quick Start
```bash
# Complete setup in 30 minutes
git clone <repository-url>
cd mini_coding_challenges
flutter pub get
flutter test
```

📖 **Detailed CI/CD Documentation**: See [CI/CD Implementation Summary](CI_CD_IMPLEMENTATION_SUMMARY.md)

## 🏗️ Architecture

### Clean Architecture Structure

```
lib/
├── core/
│   ├── di/                     # Dependency Injection
│   ├── network/                # API Client (Retrofit)
│   └── utils/                  # Utilities
└── features/
    └── transactions/
        ├── data/
        │   ├── datasources/    # Remote Data Sources
        │   ├── models/         # Data Models (JSON)
        │   └── repositories/   # Repository Implementations
        ├── domain/
        │   ├── entities/       # Business Entities
        │   ├── repositories/   # Repository Interfaces
        │   └── usecases/       # Business Logic
        └── presentation/
            ├── bloc/           # BLoC (Events, States, Logic)
            ├── pages/          # UI Screens
            └── widgets/        # Reusable Components
```

## 📦 Key Components

### 1. TransactionBloc

**Events:**
- `LoadFirstPage` - Load initial page of transactions
- `LoadNextPage` - Load next page for pagination
- `Refresh` - Refresh the transaction list

**States:**
- `Initial` - Ready to load transactions
- `Loading` - Loading first page
- `LoadingMore` - Loading additional pages
- `Loaded` - Successfully loaded with data
- `Error` - Error state with message

```dart
@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = Initial;
  const factory TransactionState.loading() = Loading;
  const factory TransactionState.loadingMore(List<Transaction> transactions) = LoadingMore;
  const factory TransactionState.loaded({
    required List<Transaction> transactions,
    required bool hasMore,
    required int currentPage,
  }) = Loaded;
  const factory TransactionState.error(String message) = Error;
}
```

### 2. Transaction Entity

```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int userId,
    required String title,
    required String description,
    required double amount,
    required DateTime date,
    required TransactionType type,
  }) = _Transaction;
}

enum TransactionType { income, expense }
```

### 3. API Integration Flow

1. **Data Source** - Uses Retrofit to make HTTP calls
2. **Repository** - Converts models to entities
3. **Use Case** - Contains business logic
4. **BLoC** - Manages state and handles events
5. **UI** - Reacts to state changes

## 🔄 Pagination Flow

### How it Works:

1. **Initial Load**: User opens screen → `LoadFirstPage` event → API call for page 1
2. **Scroll Detection**: User scrolls to bottom → `LoadNextPage` event → API call for next page
3. **State Management**: BLoC manages current page, hasMore flag, and loading states
4. **UI Updates**: List updates with new items, loading indicators show/hide

### State Transitions:

```
Initial → Loading → Loaded (with hasMore: true)
Loaded → LoadingMore → Loaded (with more items)
Loaded → LoadingMore → Loaded (with hasMore: false) // Last page
Any State → Error (on API failure)
```

### UI Response Patterns:

```dart
return state.when(
  initial: () => const Center(child: Text('Ready to load')),
  loading: () => const LoadingIndicator(),
  loadingMore: (transactions) => _buildList(transactions, isLoadingMore: true),
  loaded: (transactions, hasMore, page) => _buildList(transactions),
  error: (message) => ErrorWidget(message: message),
);
```

## 🛠️ Technical Implementation

### BLoC Event Handling

```dart
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  on<LoadFirstPage>((event, emit) async {
    emit(const TransactionState.loading());
    try {
      final transactions = await _getTransactionsUseCase(1, _pageSize);
      emit(TransactionState.loaded(
        transactions: transactions,
        hasMore: transactions.length == _pageSize,
        currentPage: 1,
      ));
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  });

  on<LoadNextPage>((event, emit) async {
    final currentState = state;
    if (currentState is Loaded && currentState.hasMore) {
      emit(TransactionState.loadingMore(currentState.transactions));
      // ... load next page logic
    }
  });
}
```

### API Integration with Retrofit

```dart
@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/posts')
  Future<List<TransactionModel>> getTransactions(
    @Query('_page') int page,
    @Query('_limit') int limit,
  );
}
```

### Model to Entity Conversion

```dart
extension TransactionModelX on TransactionModel {
  Transaction toEntity() => Transaction(
    id: id,
    userId: userId,
    title: title,
    description: body,
    amount: (id * 100.0), // Mock amount
    date: DateTime.now().subtract(Duration(days: id)),
    type: id % 2 == 0 ? TransactionType.income : TransactionType.expense,
  );
}
```

## 🚀 Getting Started

### Prerequisites

- Flutter 3.19.0 or later
- Dart 3.3.0 or later

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd mini_coding_challenges
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code:**
   ```bash
   dart run build_runner build
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📱 Features Demonstrated

### ✅ Pagination Implementation
- Infinite scroll with loading indicators
- Proper state management for pagination
- Error handling and retry functionality
- Pull-to-refresh support

### ✅ Clean Architecture
- Separation of concerns (Data, Domain, Presentation)
- Dependency inversion principle
- Testable code structure

### ✅ BLoC Pattern
- Event-driven state management
- Reactive UI updates
- Proper error handling

### ✅ Modern Flutter Practices
- Freezed for immutable classes
- Retrofit for API calls
- Dependency injection
- Material Design 3

## 🧪 Key Learning Points

### State Management
- How to handle pagination states (loading, loadingMore, loaded)
- Managing current page and hasMore flags
- Error state handling and recovery

### API Integration
- Using Retrofit for type-safe API calls
- Converting JSON models to domain entities
- Handling API pagination parameters

### UI Patterns
- Infinite scroll implementation
- Loading indicators at list bottom
- Pull-to-refresh functionality
- Error state with retry actions

### Architecture Benefits
- **Scalability**: Easy to add new features
- **Testability**: Each layer can be tested independently
- **Maintainability**: Clear separation of concerns
- **Reusability**: Components can be reused across features

## 📚 Dependencies

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6
  
  # HTTP & API
  dio: ^5.7.0
  retrofit: ^4.4.1
  json_annotation: ^4.9.0
  
  # Code Generation
  freezed_annotation: ^2.4.4
  
  # Dependency Injection
  get_it: ^8.0.0
  injectable: ^2.5.0

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  retrofit_generator: ^9.1.2
  
  # Testing
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
```

## 🎯 Best Practices Demonstrated

1. **State Management**: Proper BLoC implementation with clear event/state separation
2. **Error Handling**: Comprehensive error states and user feedback
3. **Performance**: Efficient pagination without memory leaks
4. **Code Organization**: Clean architecture with proper folder structure
5. **Type Safety**: Using Freezed and strong typing throughout
6. **Dependency Management**: Proper DI setup with GetIt

---

This project serves as a comprehensive example of implementing pagination in Flutter using modern best practices and clean architecture principles.
