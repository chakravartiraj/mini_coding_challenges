// STEP 5B: BLOC STATE - Application State Definition
// ==================================================
//
// WHAT: This file defines all possible states the transaction feature can
//       be in. States represent the current condition of the application.
//
// WHY:  In BLoC pattern, states are the output of business logic.
//       They drive UI updates and ensure predictable rendering.
//       Well-designed states make UI logic simple and bug-free.
//
// HOW:  Using Freezed union types to create a finite state machine
//       with clear state transitions and type-safe pattern matching.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';

// Generated file for Freezed union types
part 'transaction_state.freezed.dart';

// TRANSACTION STATE MACHINE
// ========================
//
// THINKING PROCESS:
// 1. What are all the possible states of transaction loading?
//    - Initial: Nothing loaded yet
//    - Loading: First page loading
//    - LoadingMore: Additional pages loading
//    - Loaded: Data successfully loaded
//    - Error: Something went wrong
//
// 2. What data does UI need for each state?
//    - Loading states: Existing data (for loadingMore)
//    - Loaded state: Transactions, pagination info
//    - Error state: Error message for display
//
// 3. How to handle pagination in state?
//    - Track current page number
//    - Track if more data is available
//    - Keep accumulated transaction list
//
// 4. How to make UI logic simple?
//    - Each state contains exactly what UI needs
//    - No complex calculations in UI layer
//    - Clear state transitions

@freezed
class TransactionState with _$TransactionState {
  // INITIAL STATE
  // ============
  //
  // WHEN: App first starts, before any data loading
  // UI BEHAVIOR: Show initial screen (empty state, welcome message, etc.)
  // TRANSITIONS TO: Loading (when user requests data)
  //
  // WHY SEPARATE FROM LOADING:
  // - Different UI treatment (might show onboarding)
  // - Analytics can track how many users get here vs actually load data
  // - Allows for lazy loading strategies

  const factory TransactionState.initial() = Initial;

  // LOADING STATE
  // ============
  //
  // WHEN: Loading first page of transactions
  // UI BEHAVIOR: Show loading indicator, hide other content
  // TRANSITIONS TO: Loaded (success) or Error (failure)
  //
  // DESIGN DECISION:
  // - No data parameter because nothing to show yet
  // - UI should display full-screen loading indicator
  // - Clear that this is initial load, not additional data

  const factory TransactionState.loading() = Loading;

  // LOADING MORE STATE
  // =================
  //
  // WHEN: Loading additional pages while existing data is visible
  // UI BEHAVIOR: Keep existing list, show loading indicator at bottom
  // TRANSITIONS TO: Loaded (success) or Error (failure)
  //
  // WHY INCLUDE TRANSACTIONS:
  // - UI needs to show existing data while loading more
  // - Provides smooth user experience
  // - Avoids flickering or empty states during pagination
  //
  // PARAMETERS:
  // - transactions: Current list to keep displaying

  const factory TransactionState.loadingMore(List<Transaction> transactions) =
      LoadingMore;

  // LOADED STATE
  // ===========
  //
  // WHEN: Data successfully loaded and displayed
  // UI BEHAVIOR: Show transaction list with pagination controls
  // TRANSITIONS TO: LoadingMore (more pages), Loading (refresh),
  //                 Error (reload fails)
  //
  // WHY THESE PARAMETERS:
  // - transactions: The actual data to display
  // - hasMore: Whether to show "load more" option
  // - currentPage: For analytics and debugging
  //
  // DESIGN DECISIONS:
  // - All parameters required to ensure complete state
  // - hasMore boolean prevents unnecessary load attempts
  // - currentPage helps with pagination logic

  const factory TransactionState.loaded({
    required List<Transaction> transactions, // The data to display
    required bool hasMore, // Can load more pages?
    required int currentPage, // Current pagination state
  }) = Loaded;

  // ERROR STATE
  // ==========
  //
  // WHEN: Any loading operation fails
  // UI BEHAVIOR: Show error message with retry option
  // TRANSITIONS TO: Loading (retry), Initial (reset)
  //
  // PARAMETERS:
  // - message: Human-readable error description for user
  //
  // WHY STRING MESSAGE:
  // - Simple and flexible for different error types
  // - UI can display directly without processing
  // - Easy to localize in future
  // - Could be enhanced with error codes later

  const factory TransactionState.error(String message) = Error;

  // FUTURE STATES (showing extensibility):
  // =====================================
  // These show how state management can evolve with features
  //
  // // Empty state when no transactions exist
  // const factory TransactionState.empty() = Empty;
  //
  // // Offline state when no network available
  // const factory TransactionState.offline({
  //   required List<Transaction> cachedTransactions,
  // }) = Offline;
  //
  // // Filtered state with search/filter criteria
  // const factory TransactionState.filtered({
  //   required List<Transaction> transactions,
  //   required String searchQuery,
  //   required TransactionType? filterType,
  // }) = Filtered;
  //
  // // Editing state for transaction CRUD operations
  // const factory TransactionState.editing({
  //   required List<Transaction> transactions,
  //   required Transaction editingTransaction,
  // }) = Editing;
}

// STATE MACHINE TRANSITIONS:
// ==========================
//
//     ┌─────────┐
//     │ Initial │
//     └────┬────┘
//          │ loadFirstPage
//          ▼
//     ┌─────────┐    success   ┌────────┐
//     │ Loading │ ──────────► │ Loaded │
//     └────┬────┘             └───┬─┬──┘
//          │                      │ │
//          │ failure              │ │ loadNextPage
//          ▼                      │ ▼
//     ┌─────────┐                 │ ┌─────────────┐
//     │  Error  │                 │ │ LoadingMore │
//     └─────────┘                 │ └──────┬──────┘
//                                 │        │
//                                 │ success│
//                                 │        ▼
//                                 │   ┌────────┐
//                                 └───│ Loaded │
//                                     └────────┘
//
// ARCHITECTURAL BENEFITS:
// ======================
//
// 1. FINITE STATE MACHINE:
//    - Clear, predictable state transitions
//    - Impossible to be in invalid states
//    - Easy to reason about application behavior
//
// 2. TYPE SAFETY:
//    - Compiler ensures all states are handled in UI
//    - No null pointer exceptions from missing data
//    - Clear contracts between BLoC and UI
//
// 3. REACTIVE UI:
//    - UI automatically updates when state changes
//    - No manual UI state management
//    - Consistent rendering across the app
//
// 4. SEPARATION OF CONCERNS:
//    - States contain only what UI needs
//    - Business logic in BLoC, presentation logic in UI
//    - Easy to test each layer independently
//
// 5. DEBUGGING:
//    - Easy to log state transitions
//    - Time-travel debugging possible
//    - Clear audit trail of user interactions
//
// WHAT HAPPENS NEXT:
// ================
// 1. BLoC receives events and produces these states
// 2. UI listens to state stream and reacts accordingly
// 3. Each state triggers specific UI behavior
// 4. State transitions drive the user experience
