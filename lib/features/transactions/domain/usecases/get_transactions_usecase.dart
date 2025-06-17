// STEP 3: USE CASE - Business Logic Orchestration
// ===============================================
//
// WHAT: This file contains the business logic for getting transactions.
//       Use cases are the entry points for business operations.
//
// WHY:  Use cases encapsulate specific business scenarios and coordinate
//       between entities and repositories. They ensure business rules
//       are applied consistently across the application.
//
// HOW:  Simple class that depends on repository interface and implements
//       the specific business logic for pagination.

import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';
import 'package:mini_coding_challenges/features/transactions/domain/repositories/transaction_repository.dart';

// GET TRANSACTIONS USE CASE
// =========================
//
// THINKING PROCESS:
// 1. What business scenario does this handle?
//    - User wants to see their transactions with pagination
//
// 2. What business rules apply?
//    - Validate page number (must be positive)
//    - Validate limit (must be reasonable range)
//    - Handle empty results gracefully
//
// 3. What does this coordinate?
//    - Takes user input (page, limit)
//    - Validates business rules
//    - Delegates data fetching to repository
//    - Returns domain entities to presentation layer
//
// 4. Should this contain UI logic?
//    - No, pure business logic only
//    - No knowledge of widgets, formatting, etc.
//    - Presentation layer handles UI concerns

class GetTransactionsUseCase {
  // CONSTRUCTOR: Dependency injection
  // ================================
  //
  // WHY CONSTRUCTOR INJECTION:
  // - Makes dependencies explicit and required
  // - Enables testing by injecting mocks
  // - Follows single responsibility principle
  // - Framework-agnostic approach

  GetTransactionsUseCase(this._repository);
  // DEPENDENCY: Repository interface for data operations
  // ==================================================
  //
  // WHY INTERFACE: Dependency inversion principle
  // - Use case depends on abstraction, not concrete implementation
  // - Enables testing with mock repositories
  // - Allows swapping data sources without changing business logic

  final TransactionRepository _repository;

  // MAIN BUSINESS OPERATION
  // ======================
  //
  // DESIGN DECISIONS:
  // 1. Method name 'call' makes this class callable like a function
  // 2. Parameters match what UI needs for pagination
  // 3. Return type is domain entities, not data models
  // 4. Async because data operations are inherently async

  Future<List<Transaction>> call(int page, int limit) async {
    // BUSINESS RULE VALIDATION
    // =======================
    //
    // WHY VALIDATE HERE:
    // - Use cases are responsible for business rule enforcement
    // - Prevent invalid data from reaching repository layer
    // - Fail fast with clear error messages
    // - Consistent validation across all entry points

    // Validate page number
    if (page < 1) {
      throw ArgumentError('Page number must be greater than 0');
    }

    // Validate page limit
    if (limit < 1) {
      throw ArgumentError('Limit must be greater than 0');
    }

    // Business rule: Reasonable upper limit to prevent memory issues
    if (limit > 100) {
      throw ArgumentError(
        'Limit too large, maximum is 100 transactions per page',
      );
    }

    // DELEGATE TO REPOSITORY
    // =====================
    //
    // WHY SIMPLE DELEGATION:
    // - Repository handles data concerns (network, caching, etc.)
    // - Use case handles business concerns (validation, orchestration)
    // - Clean separation of responsibilities
    // - Easy to add business logic later (sorting, filtering, etc.)

    try {
      final transactions = await _repository.getTransactions(page, limit);

      // FUTURE BUSINESS LOGIC COULD GO HERE:
      // ===================================
      // - Sort transactions by date/amount
      // - Filter by user preferences
      // - Apply business calculations
      // - Aggregate data for reporting
      // - Cache frequently accessed data

      return transactions;
    } catch (error) {
      // ERROR HANDLING STRATEGY
      // ======================
      //
      // THINKING PROCESS:
      // 1. Should use case handle errors or let them bubble up?
      //    - Let them bubble for now, presentation layer decides how to handle
      // 2. Should we log errors here?
      //    - No, that's a cross-cutting concern for infrastructure layer
      // 3. Should we transform errors?
      //    - Could add business-specific error types in future

      // For now, let repository errors bubble up
      // Presentation layer will handle user-facing error messages
      rethrow;
    }
  }

  // FUTURE BUSINESS OPERATIONS (showing extensibility):
  // ==================================================

  // // Get transactions with business filters
  // Future<List<Transaction>> getFilteredTransactions({
  //   required int page,
  //   required int limit,
  //   TransactionType? type,
  //   DateTime? startDate,
  //   DateTime? endDate,
  //   double? minAmount,
  //   double? maxAmount,
  // }) async {
  //   // Validate business rules for filters
  //   // Apply business logic for date ranges
  //   // Delegate to repository with validated parameters
  // }

  // // Calculate user's account balance
  // Future<double> calculateBalance() async {
  //   // Get all transactions
  //   // Apply business logic: income - expenses
  //   // Return calculated balance
  // }

  // // Get spending summary for a period
  // Future<SpendingSummary> getSpendingSummary({
  //   required DateTime startDate,
  //   required DateTime endDate,
  // }) async {
  //   // Business logic for date validation
  //   // Fetch transactions in date range
  //   // Calculate totals, categories, trends
  //   // Return business summary object
  // }
}

// ARCHITECTURAL BENEFITS:
// ======================
//
// 1. SINGLE RESPONSIBILITY:
//    - Only handles "get transactions" business scenario
//    - Clear, focused purpose
//    - Easy to understand and maintain
//
// 2. BUSINESS RULE ENFORCEMENT:
//    - Validates input parameters
//    - Ensures data integrity
//    - Consistent behavior across app
//
// 3. TESTABILITY:
//    - Easy to unit test with mock repository
//    - Business logic separated from data logic
//    - Fast, reliable tests
//
// 4. FLEXIBILITY:
//    - Easy to add business logic without changing other layers
//    - Can compose with other use cases
//    - Framework-independent
//
// 5. DEPENDENCY INVERSION:
//    - Depends on repository interface, not implementation
//    - Enables different data sources
//    - Promotes loose coupling
//
// WHAT HAPPENS NEXT:
// ================
// 1. Data layer implements the repository interface
// 2. Presentation layer (BLoC) calls this use case
// 3. Dependency injection wires everything together
// 4. Business logic remains isolated and pure
