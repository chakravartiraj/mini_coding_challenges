// STEP 1: DOMAIN ENTITY - The Core Business Object
// ================================================
//
// WHAT: This file defines the Transaction entity, which represents
//       the core business object in our application.
//
// WHY:  In Clean Architecture, entities are the innermost layer.
//       They contain enterprise business rules and are independent
//       of any framework, UI, or external concerns.
//
// HOW:  Using Equatable for value equality comparison.
//       This ensures two Transaction objects with same data are equal.

import 'package:equatable/equatable.dart';

// ENUM FOR TRANSACTION TYPE
// =========================
//
// THINKING PROCESS:
// 1. What types of transactions exist in personal finance?
//    - Money coming in (income)
//    - Money going out (expense)
//
// 2. Why enum instead of string or boolean?
//    - Type safety at compile time
//    - Better performance than strings
//    - IDE autocomplete support
//    - Prevents typos and invalid values
//    - More extensible than boolean (can add transfer later)

enum TransactionType {
  income, // Money received - salary, freelance, gifts, etc.
  expense, // Money spent - groceries, bills, entertainment, etc.
}

// MAIN TRANSACTION ENTITY
// =======================
//
// DESIGN DECISIONS:
// 1. Extends Equatable for value equality (two objects with same data are
//    equal)
// 2. All fields are final and required for immutability and data integrity
// 3. Uses comprehensive property list for equality comparison

class Transaction extends Equatable {
  // CONSTRUCTOR
  // ===========
  //
  // THINKING PROCESS:
  // 1. All fields required because incomplete transaction data is meaningless
  // 2. Using named parameters for better readability and maintainability
  // 3. Const constructor for performance optimization when possible

  const Transaction({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
  // CORE PROPERTIES
  // ===============

  // Unique identifier - essential for list operations, caching, and updates
  // WHY: Every transaction needs unique identification
  final int id;

  // User association - important for multi-user systems and data filtering
  // WHY: Transactions belong to specific users
  final int userId;

  // Human-readable transaction title for quick identification in lists
  // WHY: Users need to quickly identify transactions
  final String title;

  // Detailed description providing more context about the transaction
  // WHY: Sometimes title isn't enough, users need more details
  final String description;

  // Transaction amount - using double for currency precision
  // WHY: Financial amounts often have decimal places
  // NOTE: In production, consider using Decimal type for better precision
  final double amount;

  // When the transaction occurred - crucial for sorting, filtering,
  // and reporting. WHY: Time is essential for financial tracking
  final DateTime date;

  // Transaction type - determines UI representation and balance calculations
  // WHY: Distinguishes between money in vs money out
  final TransactionType type;

  // EQUATABLE OVERRIDE
  // ==================
  //
  // WHY: This tells Equatable which properties to use for equality comparison
  // HOW: Two Transaction objects are equal if all these properties match
  // BENEFIT: Enables proper comparison in lists, sets, and testing

  @override
  List<Object?> get props => [
    id, // Primary identifier
    userId, // User association
    title, // Transaction title
    description, // Additional details
    amount, // Money value
    date, // When it happened
    type, // Income or expense
  ];

  // BUSINESS LOGIC METHODS
  // =====================
  //
  // These computed properties encapsulate business rules in the domain layer
  // WHY: Keep business logic close to the data it operates on

  // Is this transaction bringing money in?
  bool get isIncome => type == TransactionType.income;

  // Is this transaction taking money out?
  bool get isExpense => type == TransactionType.expense;

  // Amount with appropriate sign for calculations
  // WHY: For balance calculations, expenses should be negative
  double get signedAmount => isIncome ? amount : -amount;

  // Formatted amount for display purposes
  // WHY: Consistent currency formatting across the app
  String get formattedAmount {
    final sign = isIncome ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  // Friendly date formatting for UI
  // WHY: Raw DateTime isn't user-friendly
  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  // Custom toString for better debugging and logging
  @override
  String toString() => 'Transaction(id: $id, userId: $userId, title: $title, '
        'description: $description, amount: $amount, date: $date, '
        'type: $type)';
}

// ARCHITECTURAL BENEFITS OF THIS DESIGN:
// ======================================
//
// 1. INDEPENDENCE: This entity doesn't depend on Flutter, HTTP, or databases
// 2. TESTABILITY: Easy to create test instances and verify business rules
// 3. IMMUTABILITY: Once created, objects can't be accidentally modified
// 4. VALUE EQUALITY: Two transactions with same data are considered equal
// 5. BUSINESS LOGIC: Domain rules are encapsulated in the entity itself
// 6. TYPE SAFETY: Enum prevents invalid transaction types
// 7. EXTENSIBILITY: Easy to add new properties or business rules
//
// WHAT HAPPENS NEXT:
// =================
// 1. Repository interface will define how to fetch/store transactions
// 2. Use cases will orchestrate business operations on transactions
// 3. Data models will handle serialization/deserialization
// 4. UI will use these entities for display and interaction
