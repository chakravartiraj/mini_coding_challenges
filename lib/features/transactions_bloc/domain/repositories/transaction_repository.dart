// STEP 2: DOMAIN REPOSITORY CONTRACT - The Business Rules Interface
// =================================================================
//
// WHAT: This file defines the contract (interface) for transaction data
//       operations. It's an abstract definition of what operations are
//       possible, not how they work.
//
// WHY:  In Clean Architecture, the domain layer defines interfaces that
//       outer layers must implement. This creates dependency inversion -
//       business logic doesn't depend on data sources, data sources depend
//       on business contracts.
//
// HOW:  Using abstract class to define method signatures that data layer
//       implements.

import 'package:mini_coding_challenges/features/transactions_bloc/domain/entities/transaction.dart';

// REPOSITORY INTERFACE
// ===================
//
// THINKING PROCESS:
// 1. What operations does our business logic need on transactions?
//    - Fetch transactions (with pagination for performance)
//    - Could add: Create, Update, Delete in future
//
// 2. What parameters do we need for fetching?
//    - Page number for pagination
//    - Limit (page size) for controlling data volume
//
// 3. What should we return?
//    - List of Transaction entities (domain objects)
//    - Async because data comes from network/database
//
// 4. Should we handle errors here?
//    - No, let implementation decide error handling strategy
//    - Keep interface focused on happy path
//    - Exceptions will bubble up naturally

abstract class TransactionRepository {
  // PRIMARY BUSINESS OPERATION: Get paginated transactions
  // ====================================================
  //
  // WHY PAGINATION:
  // - Mobile apps need to handle large datasets efficiently
  // - Loading all transactions at once would be slow and memory-intensive
  // - Better user experience with incremental loading
  //
  // PARAMETERS:
  // - page: Which page to fetch (1-based indexing for human-readability)
  // - limit: How many transactions per page (controls memory usage and
  //   network load)
  //
  // RETURN TYPE:
  // - Future<List<Transaction>>: Async list of domain entities
  // - Using domain entities ensures this layer is pure business logic
  // - No knowledge of JSON, HTTP, databases, or any technical details

  Future<List<Transaction>> getTransactions(int page, int limit);

  // FUTURE OPERATIONS (not implemented yet, but showing extensibility):
  //
  // // Create a new transaction
  // Future<Transaction> createTransaction(Transaction transaction);
  //
  // // Update an existing transaction
  // Future<Transaction> updateTransaction(Transaction transaction);
  //
  // // Delete a transaction
  // Future<void> deleteTransaction(int transactionId);
  //
  // // Get a single transaction by ID
  // Future<Transaction?> getTransactionById(int id);
  //
  // // Search transactions by criteria
  // Future<List<Transaction>> searchTransactions({
  //   String? query,
  //   TransactionType? type,
  //   DateTime? startDate,
  //   DateTime? endDate,
  // });
}

// ARCHITECTURAL BENEFITS OF THIS APPROACH:
// ========================================
//
// 1. DEPENDENCY INVERSION:
//    - Business logic (use cases) depend on this interface
//    - Data layer implements this interface
//    - Creates flexible, testable architecture
//
// 2. TESTING:
//    - Easy to create mock implementations for testing
//    - Business logic can be tested without real data sources
//    - Fast, reliable unit tests
//
// 3. FLEXIBILITY:
//    - Can swap data sources (API, database, cache) without changing
//      business logic
//    - Implementation details are hidden from business layer
//    - Future-proof architecture
//
// 4. SINGLE RESPONSIBILITY:
//    - This interface only cares about what operations are available
//    - Implementation cares about how operations work
//    - Clear separation of concerns
//
// 5. DOMAIN PURITY:
//    - Interface only deals with domain entities
//    - No technical concerns leak into business layer
//    - Clean, focused contracts
//
// WHAT HAPPENS NEXT:
// =================
// 1. Use cases will depend on this interface for data operations
// 2. Data layer will implement this interface with concrete logic
// 3. Dependency injection will wire implementations to interfaces
// 4. Business logic remains isolated and testable
