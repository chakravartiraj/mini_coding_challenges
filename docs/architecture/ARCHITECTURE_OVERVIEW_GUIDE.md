# 🏗️ Project Architecture

> **How the Mini Coding Challenges app is organized and why**

## 🎯 Architecture Overview

This app uses **Clean Architecture** with **BLoC pattern** to keep code organized and testable:

```
📱 App
├── 🎨 Presentation (UI)     → What users see
├── 💼 Business Logic        → App rules and state  
└── 💾 Data                  → APIs and storage
```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Shared utilities
│   ├── constants/              # App-wide constants
│   ├── error/                  # Error handling
│   ├── network/                # HTTP client setup
│   └── utils/                  # Helper functions
├── features/                    # Main app features
│   └── transactions/           # Transaction list feature
│       ├── data/               # API calls, models
│       ├── domain/             # Business logic
│       └── presentation/       # UI screens, BLoC
└── shared/                      # Reusable components
    ├── widgets/                # Common UI widgets
    └── theme/                  # App styling
```

## 🧩 Clean Architecture Layers

### **1. Presentation Layer** (UI)
**What it does:** Shows screens and handles user interactions

```
features/transactions/presentation/
├── bloc/                        # State management
│   ├── transactions_bloc.dart  # Business logic coordinator
│   ├── transactions_event.dart # User actions
│   └── transactions_state.dart # UI states
└── pages/
    └── transactions_page.dart  # Main screen
```

**Key principle:** UI only knows about displaying data and sending user actions.

### **2. Domain Layer** (Business Rules)
**What it does:** Contains app's core business logic

```
features/transactions/domain/
├── entities/                    # Core data models
│   └── transaction.dart        # Pure transaction data
├── repositories/               # Data contracts
│   └── transaction_repository.dart  # Interface
└── usecases/                   # Business operations
    └── get_transactions.dart   # Pagination logic
```

**Key principle:** No dependencies on UI or external libraries.

### **3. Data Layer** (External World)
**What it does:** Fetches data from APIs, databases, etc.

```
features/transactions/data/
├── models/                      # JSON conversion
│   └── transaction_model.dart  # API response mapping
├── repositories/               # Implementation
│   └── transaction_repository_impl.dart
└── datasources/                # External data
    └── transaction_remote_datasource.dart  # API calls
```

**Key principle:** Handles external data and converts it for the app.

## 🔄 BLoC Pattern Flow

**How data flows through the app:**

```
1. User Action (tap, scroll) 
   ↓
2. UI sends Event to BLoC
   ↓  
3. BLoC processes Event
   ↓
4. BLoC calls UseCase
   ↓
5. UseCase calls Repository
   ↓
6. Repository fetches data
   ↓
7. Data flows back up
   ↓
8. BLoC emits new State
   ↓
9. UI rebuilds with new data
```

**Example - Loading more transactions:**
```dart
// 1. User scrolls to bottom
onScrollEnd() {
  context.read<TransactionsBloc>().add(LoadMoreTransactions());
}

// 2. BLoC handles event
if (event is LoadMoreTransactions) {
  final result = await getTransactions(page: currentPage + 1);
  emit(TransactionsLoaded(transactions: [...current, ...new]));
}

// 3. UI rebuilds automatically
BlocBuilder<TransactionsBloc, TransactionsState>(
  builder: (context, state) {
    if (state is TransactionsLoaded) {
      return ListView.builder(...);  // Shows updated list
    }
  },
)
```

## 🎨 Key Design Patterns

### **Dependency Injection**
```dart
// Services registered once at app start
GetIt.instance.registerSingleton<TransactionRepository>(
  TransactionRepositoryImpl(remoteDataSource)
);

// Used throughout the app
final repository = GetIt.instance<TransactionRepository>();
```

### **Repository Pattern**
```dart
// Abstract interface (domain layer)
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(int page);
}

// Concrete implementation (data layer)  
class TransactionRepositoryImpl implements TransactionRepository {
  @override
  Future<List<Transaction>> getTransactions(int page) {
    // API call logic
  }
}
```

### **Freezed for Immutable Data**
```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String description,
    required double amount,
  }) = _Transaction;
}
```

## 🧪 Why This Architecture?

### **Benefits**
- **Testable** - Each layer can be tested independently
- **Maintainable** - Changes in one layer don't break others
- **Scalable** - Easy to add new features
- **Readable** - Clear separation of concerns

### **Example - Adding New Feature**
To add a "favorites" feature:
1. **Domain** - Create `Favorite` entity and use cases
2. **Data** - Add favorites API calls
3. **Presentation** - Create favorites screen and BLoC
4. **Core stays the same** - No changes needed

## 🔍 Code Examples

### **Simple BLoC Usage**
```dart
// In your widget
BlocConsumer<TransactionsBloc, TransactionsState>(
  listener: (context, state) {
    if (state is TransactionsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message))
      );
    }
  },
  builder: (context, state) {
    return state.when(
      initial: () => CircularProgressIndicator(),
      loading: () => CircularProgressIndicator(),
      loaded: (transactions) => TransactionsList(transactions),
      error: (message) => ErrorWidget(message),
    );
  },
)
```

### **Use Case Implementation**
```dart
class GetTransactions {
  final TransactionRepository repository;
  
  GetTransactions(this.repository);
  
  Future<Result<List<Transaction>>> call({
    required int page,
    int limit = 20,
  }) async {
    try {
      final transactions = await repository.getTransactions(page);
      return Success(transactions);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
```

## ➡️ Learn More

- **[BLoC Pattern Details](BLOC_PATTERN.md)** - Deep dive into state management
- **[Clean Architecture Guide](CLEAN_ARCHITECTURE.md)** - Architecture principles
- **[Features Overview](../features/FEATURES_OVERVIEW_GUIDE.md)** - Specific app features

*Good architecture is invisible when it works well - you just focus on building features.*

## 🏛️ **Architecture Layers**

```
┌─────────────────────────────────────┐
│           Presentation              │  ← UI, BLoC, Widgets
├─────────────────────────────────────┤
│              Domain                 │  ← Entities, Use Cases, Repositories
├─────────────────────────────────────┤
│               Data                  │  ← Data Sources, Models, Repositories
└─────────────────────────────────────┘
```

## 📖 **Reading Order**

1. **Start with**: [Implementation Summary](./SUMMARY.md) for overview
2. **Deep dive**: [Complete Implementation Guide](./COMPLETE_IMPLEMENTATION_GUIDE.md) for details
3. **Hands-on**: [Implementation Guide](./IMPLEMENTATION_GUIDE.md) for practical steps

---

*For navigation back to main documentation index, see [../DOCUMENTATION_HUB.md](../DOCUMENTATION_HUB.md)*
