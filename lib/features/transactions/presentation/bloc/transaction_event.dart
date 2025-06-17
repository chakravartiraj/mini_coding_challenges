// STEP 5A: BLOC EVENTS - User Intent Declaration
// ==============================================
//
// WHAT: This file defines all possible user actions that can happen
//       in the transaction feature. Events represent user intentions.
//
// WHY:  In BLoC pattern, events are the input to the business logic.
//       They create a clear contract of what actions are possible
//       and enable predictable state management.
//
// HOW:  Using Freezed union types to create type-safe event classes
//       with zero boilerplate and excellent pattern matching.

import 'package:freezed_annotation/freezed_annotation.dart';

// Generated file for Freezed union types
part 'transaction_event.freezed.dart';

// TRANSACTION EVENTS
// =================
//
// THINKING PROCESS:
// 1. What can users do with transactions?
//    - Load initial data when screen opens
//    - Load more data when scrolling (pagination)
//    - Refresh data when pulling to refresh
//
// 2. What events drive pagination behavior?
//    - LoadFirstPage: Start fresh, clear existing data
//    - LoadNextPage: Append to existing data
//    - Refresh: Reload from beginning, clear cache
//
// 3. Why separate events instead of one generic "load"?
//    - Different loading behaviors (replace vs append vs refresh)
//    - Clear intent makes debugging easier
//    - Type safety prevents mixing up operations
//    - Easy to add event-specific parameters later

@freezed
class TransactionEvent with _$TransactionEvent {
  // INITIAL PAGE LOAD EVENT
  // ======================
  //
  // WHEN: User first opens transaction screen
  // BEHAVIOR: Clear any existing data and load first page
  // USE CASE: App startup, navigation to transactions screen
  //
  // WHY SEPARATE FROM REFRESH:
  // - Initial load might have different logic (caching, etc.)
  // - Clear separation of concerns
  // - Different loading indicators might be shown
  // - Analytics can track different user behaviors

  const factory TransactionEvent.loadFirstPage() = LoadFirstPage;

  // PAGINATION EVENT
  // ===============
  //
  // WHEN: User scrolls to bottom of list and more data is available
  // BEHAVIOR: Keep existing data and append new page
  // USE CASE: Infinite scroll, load more button
  //
  // DESIGN DECISIONS:
  // - No page parameter needed, BLoC tracks current page internally
  // - Event represents user intent, not technical details
  // - BLoC handles the complexity of page management

  const factory TransactionEvent.loadNextPage() = LoadNextPage;

  // REFRESH EVENT
  // ============
  //
  // WHEN: User pulls to refresh or explicitly requests fresh data
  // BEHAVIOR: Clear existing data and reload from beginning
  // USE CASE: Pull-to-refresh gesture, refresh button, error retry
  //
  // WHY DIFFERENT FROM LOAD_FIRST_PAGE:
  // - Might clear caches or force network requests
  // - Different UI feedback (refresh indicator vs loading screen)
  // - Analytics distinction between initial load and user refresh
  // - Could have different error handling strategies

  const factory TransactionEvent.refresh() = Refresh;

  // FUTURE EVENTS (showing extensibility):
  // =====================================
  // These show how the event system can grow with new features
  //
  // // Filter transactions by type
  // const factory TransactionEvent.filterByType(TransactionType type) =
  //     FilterByType;
  //
  // // Search transactions
  // const factory TransactionEvent.search(String query) = Search;
  //
  // // Sort transactions
  // const factory TransactionEvent.sortBy(SortCriteria criteria) = SortBy;
  //
  // // Select date range
  // const factory TransactionEvent.filterByDateRange({
  //   required DateTime startDate,
  //   required DateTime endDate,
  // }) = FilterByDateRange;
  //
  // // Delete transaction
  // const factory TransactionEvent.deleteTransaction(int transactionId) =
  //     DeleteTransaction;
  //
  // // Create new transaction
  // const factory TransactionEvent.createTransaction(
  //     Transaction transaction) = CreateTransaction;
}

// ARCHITECTURAL BENEFITS OF THIS DESIGN:
// ======================================
//
// 1. TYPE SAFETY:
//    - Freezed generates sealed union types
//    - Impossible to create invalid events
//    - Compile-time guarantees of exhaustive handling
//
// 2. PATTERN MATCHING:
//    - BLoC can use when() to handle different events
//    - Clear, readable event handling logic
//    - Compiler ensures all events are handled
//
// 3. IMMUTABILITY:
//    - Events cannot be modified after creation
//    - Prevents accidental state corruption
//    - Enables time-travel debugging
//
// 4. ZERO BOILERPLATE:
//    - No manual toString, equality, or hashCode
//    - Freezed generates all necessary methods
//    - Focus on business logic, not plumbing
//
// 5. DISCOVERABILITY:
//    - All possible actions in one place
//    - Easy to see what the feature can do
//    - Self-documenting API
//
// 6. EXTENSIBILITY:
//    - Easy to add new events without breaking existing code
//    - Type system guides implementation
//    - Clear upgrade path for new features
//
// WHAT HAPPENS NEXT:
// ================
// 1. BLoC receives these events from UI layer
// 2. BLoC maps events to business operations
// 3. BLoC calls use cases to execute business logic
// 4. BLoC emits new states based on results
// 5. UI reacts to state changes and updates display
