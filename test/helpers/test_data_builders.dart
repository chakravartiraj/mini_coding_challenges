// Test Data Builders and Utilities
// =================================
//
// This file provides test data builders, mock objects, and testing utilities
// for the Mini Coding Challenges project. It follows industry best practices
// for test data management and object creation.

import 'package:mini_coding_challenges/features/transactions_bloc/domain/entities/transaction.dart';

/// Test data builder for Transaction entities
///
/// Provides factory methods for creating test transactions with sensible
/// defaults and easy customization for specific test scenarios.
class TransactionTestDataBuilder {
  /// Creates a test income transaction with customizable properties
  static Transaction income({
    int id = 1,
    int userId = 1,
    String title = 'Test Income',
    String description = 'Test income description',
    double amount = 100.0,
    DateTime? date,
  }) => Transaction(
    id: id,
    userId: userId,
    title: title,
    description: description,
    amount: amount,
    date: date ?? DateTime(2024),
    type: TransactionType.income,
  );

  /// Creates a test expense transaction with customizable properties
  static Transaction expense({
    int id = 2,
    int userId = 1,
    String title = 'Test Expense',
    String description = 'Test expense description',
    double amount = 50.0,
    DateTime? date,
  }) => Transaction(
    id: id,
    userId: userId,
    title: title,
    description: description,
    amount: amount,
    date: date ?? DateTime(2024),
    type: TransactionType.expense,
  );

  /// Creates a list of mixed transaction types for comprehensive testing
  static List<Transaction> mixedTransactions({int count = 5}) {
    final transactions = <Transaction>[];

    for (int i = 1; i <= count; i++) {
      final isIncome = i % 2 == 1;
      transactions.add(
        isIncome
            ? income(
                id: i,
                title: 'Income $i',
                amount: 100.0 * i,
                date: DateTime(2024, 1, i),
              )
            : expense(
                id: i,
                title: 'Expense $i',
                amount: 50.0 * i,
                date: DateTime(2024, 1, i),
              ),
      );
    }

    return transactions;
  }

  /// Creates a paginated list of transactions for pagination testing
  static List<Transaction> paginatedTransactions({
    required int page,
    required int pageSize,
    String prefix = 'Transaction',
  }) {
    final transactions = <Transaction>[];
    final startId = (page - 1) * pageSize + 1;

    for (int i = 0; i < pageSize; i++) {
      final id = startId + i;
      final isIncome = id % 2 == 1;

      transactions.add(
        isIncome
            ? income(
                id: id,
                title: '$prefix $id',
                amount: 100.0 + i,
                date: DateTime(2024, 1, i + 1),
              )
            : expense(
                id: id,
                title: '$prefix $id',
                amount: 50.0 + i,
                date: DateTime(2024, 1, i + 1),
              ),
      );
    }

    return transactions;
  }

  /// Creates transactions with edge case values for robust testing
  static List<Transaction> edgeCaseTransactions() => [
    // Zero amount
    income(amount: 0, title: 'Zero Amount'),

    // Very large amount
    expense(amount: 999999.99, title: 'Large Amount'),

    // Very small amount
    income(id: 3, amount: 0.01, title: 'Small Amount'),

    // Long title
    expense(
      id: 4,
      title: 'Very Long Transaction Title That Exceeds Normal Length',
      amount: 100,
    ),

    // Empty description
    income(id: 5, description: '', amount: 50),

    // Special characters in title
    expense(id: 6, title: 'Special!@#\$%^&*()Transaction', amount: 75),

    // Future date
    income(id: 7, date: DateTime(2030, 12, 31), amount: 200),

    // Past date
    expense(id: 8, date: DateTime(1990), amount: 25),
  ];
}

/// Test constants for consistent test data
class TestConstants {
  /// Standard test user ID
  static const int testUserId = 1;

  /// Standard page size for pagination tests
  static const int pageSize = 20;

  /// Default test amounts
  static const double defaultIncomeAmount = 100;
  static const double defaultExpenseAmount = 50;

  /// Test date ranges
  static final DateTime testStartDate = DateTime(2024);
  static final DateTime testEndDate = DateTime(2024, 12, 31);

  /// Error messages for testing
  static const String networkErrorMessage = 'Network error occurred';
  static const String timeoutErrorMessage = 'Request timeout';
  static const String serverErrorMessage = 'Internal server error';
  static const String validationErrorMessage = 'Validation failed';

  /// API endpoint constants
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String transactionsEndpoint = '/posts';
}

/// Utility functions for test assertions and validations
class TestUtils {
  /// Validates that a transaction has all required fields
  static bool isValidTransaction(Transaction transaction) => transaction.id > 0 &&
        transaction.userId > 0 &&
        transaction.title.isNotEmpty &&
        transaction.amount >= 0 &&
        transaction.date.isValid;

  /// Validates that a list of transactions is properly sorted by date
  static bool isTransactionListSortedByDate(List<Transaction> transactions) {
    if (transactions.length <= 1) return true;

    for (int i = 1; i < transactions.length; i++) {
      if (transactions[i].date.isBefore(transactions[i - 1].date)) {
        return false;
      }
    }
    return true;
  }

  /// Calculates the total balance from a list of transactions
  static double calculateTotalBalance(List<Transaction> transactions) => transactions.fold(
      0,
      (sum, transaction) => sum + transaction.signedAmount,
    );

  /// Filters transactions by type
  static List<Transaction> filterByType(
    List<Transaction> transactions,
    TransactionType type,
  ) => transactions.where((t) => t.type == type).toList();

  /// Creates a date range for testing
  static List<DateTime> createDateRange(
    DateTime start,
    DateTime end,
    int count,
  ) {
    final dates = <DateTime>[];
    final duration = end.difference(start);
    final step = duration.inDays / (count - 1);

    for (int i = 0; i < count; i++) {
      dates.add(start.add(Duration(days: (step * i).round())));
    }

    return dates;
  }

  /// Validates pagination parameters
  static bool isValidPaginationParams(int page, int limit) => page > 0 && limit > 0 && limit <= 100;

  /// Creates a delay for testing async operations
  static Future<void> shortDelay([Duration? duration]) async {
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 100));
  }

  /// Validates JSON response structure
  static bool isValidJsonResponse(Map<String, dynamic> json) => json.containsKey('id') &&
        json.containsKey('userId') &&
        json.containsKey('title') &&
        json.containsKey('body');
}

/// Custom matchers for enhanced test assertions
class CustomMatchers {
  /// Matcher for transaction equality with tolerance for floating point amounts
  static bool transactionEquals(
    Transaction actual,
    Transaction expected, {
    double tolerance = 0.01,
  }) => actual.id == expected.id &&
        actual.userId == expected.userId &&
        actual.title == expected.title &&
        actual.description == expected.description &&
        (actual.amount - expected.amount).abs() < tolerance &&
        actual.date == expected.date &&
        actual.type == expected.type;

  /// Matcher for validating transaction list properties
  static bool isValidTransactionList(
    List<Transaction> transactions, {
    int? expectedLength,
    bool shouldBeSorted = false,
    TransactionType? filterType,
  }) {
    // Check length if specified
    if (expectedLength != null && transactions.length != expectedLength) {
      return false;
    }

    // Check if all transactions are valid
    if (!transactions.every(TestUtils.isValidTransaction)) {
      return false;
    }

    // Check sorting if specified
    if (shouldBeSorted &&
        !TestUtils.isTransactionListSortedByDate(transactions)) {
      return false;
    }

    // Check type filter if specified
    if (filterType != null &&
        !transactions.every((t) => t.type == filterType)) {
      return false;
    }

    return true;
  }
}

extension DateTimeTestExtensions on DateTime {
  /// Checks if a DateTime is valid (not null and within reasonable bounds)
  bool get isValid => year >= 1900 && year <= 2100;

  /// Checks if a DateTime is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if a DateTime is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Checks if a DateTime is in the future
  bool get isFuture => isAfter(DateTime.now());
}
