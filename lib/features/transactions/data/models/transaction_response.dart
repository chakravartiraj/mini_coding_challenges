// STEP 4: DATA MODEL - External Data Representation
// =================================================
//
// WHAT: This file defines the data model for transaction responses from APIs.
//       It handles serialization/deserialization and conversion to
//       domain entities.
//
// WHY:  In Clean Architecture, the data layer is responsible for external
//       concerns like JSON parsing, API responses, and database schemas.
//       These models shield the domain layer from external data format
//       changes.
//
// HOW:  Using Freezed for immutability and JSON serialization code
//       generation. Includes conversion methods to transform data models
//       into domain entities.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';

// Generated files for Freezed JSON serialization
part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

// TRANSACTION DATA MODEL
// =====================
//
// THINKING PROCESS:
// 1. What does the API response look like?
//    - Using JSONPlaceholder API which returns posts
//    - Mapping post fields to transaction concepts
//    - id -> id, userId -> userId, title -> title, body -> description
//
// 2. Why separate model from entity?
//    - API structure might not match business needs
//    - API fields might change without affecting business logic
//    - Need to transform external data into internal concepts
//    - JSON annotations would pollute domain entities
//
// 3. How to handle missing transaction fields?
//    - Mock the missing data (amount, date, type)
//    - Create realistic test data for demo purposes
//    - In production, API would provide all necessary fields

@freezed
class TransactionModel with _$TransactionModel {
  // FACTORY CONSTRUCTOR
  // ==================
  //
  // WHY FREEZED:
  // - Immutable data structures prevent accidental mutations
  // - Automatic JSON serialization/deserialization
  // - Type-safe equality comparison
  // - Built-in copyWith method for updates

  const factory TransactionModel({
    // Direct mapping from API fields
    // =============================

    // Unique identifier from API
    // Maps directly to domain entity id
    required int id,

    // User who created the post/transaction
    // Maps to domain entity userId
    required int userId,

    // Post title becomes transaction title
    // Short, descriptive text for quick identification
    required String title,

    // Post body becomes transaction description
    // Longer text with more details
    required String body,

    // NOTE: API doesn't provide amount, date, or type
    // These will be generated in the conversion method
    // In real app, API would include all necessary fields
  }) = _TransactionModel;

  // JSON SERIALIZATION
  // =================
  //
  // WHY AUTOMATIC GENERATION:
  // - Reduces boilerplate code
  // - Prevents manual serialization errors
  // - Handles nested objects and lists automatically
  // - Maintains type safety during conversion

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

// CONVERSION EXTENSION
// ===================
//
// THINKING PROCESS:
// 1. How to convert data model to domain entity?
//    - Map direct fields (id, userId, title)
//    - Transform body -> description
//    - Generate missing fields (amount, date, type)
//
// 2. How to generate realistic mock data?
//    - Amount based on ID for deterministic results
//    - Date in the past, varying by ID
//    - Alternate income/expense based on ID
//
// 3. Why extension instead of method in class?
//    - Keeps conversion logic separate from data structure
//    - Easier to test conversion logic independently
//    - Follows single responsibility principle

extension TransactionModelX on TransactionModel {
  // CONVERSION TO DOMAIN ENTITY
  // ==========================
  //
  // PURPOSE: Transform external data format into internal business object
  // STRATEGY: Map direct fields + generate missing demo data

  Transaction toEntity() => Transaction(
    // DIRECT FIELD MAPPINGS
    // ====================

    // API ID maps directly to entity ID
    id: id,

    // API userId maps directly to entity userId
    userId: userId,

    // API title maps directly to entity title
    title: title,

    // API body becomes entity description
    // WHY: "body" is technical API term, "description" is business term
    description: body,

    // GENERATED DEMO DATA
    // ==================
    // In production app, these would come from API

    // Generate amount based on ID for deterministic, varied results
    // WHY: Multiplying by 100 gives realistic dollar amounts
    // FORMULA: ID 1 = $100, ID 2 = $200, etc.
    amount: id * 100.0,

    // Generate dates in the past, varying by ID
    // WHY: Recent transactions are more realistic
    // STRATEGY: Subtract days equal to ID from current date
    date: DateTime.now().subtract(Duration(days: id)),

    // Alternate between income and expense based on ID
    // WHY: Provides variety in transaction types for demo
    // LOGIC: Even IDs = income, Odd IDs = expense
    type: id % 2 == 0 ? TransactionType.income : TransactionType.expense,
  );

  // FUTURE CONVERSION METHODS (showing extensibility):
  // =================================================

  // // Convert to different data formats
  // Map<String, dynamic> toFirestore() => {
  //   'id': id,
  //   'user_id': userId,
  //   'title': title,
  //   'description': body,
  //   'created_at': DateTime.now().toIso8601String(),
  // };

  // // Create from different API response format
  // static TransactionModel fromAlternativeApi(Map<String, dynamic> json) {
  //   return TransactionModel(
  //     id: json['transaction_id'],
  //     userId: json['user']['id'],
  //     title: json['summary'],
  //     body: json['notes'],
  //   );
  // }
}

// DESIGN DECISIONS EXPLAINED:
// ===========================
//
// 1. FREEZED VS REGULAR CLASS:
//    - Immutability prevents accidental data corruption
//    - Automatic serialization reduces boilerplate
//    - Generated equality/hashCode/toString for debugging
//    - Better performance than manual implementations
//
// 2. EXTENSION FOR CONVERSION:
//    - Keeps data model focused on structure
//    - Makes conversion logic easy to find and test
//    - Allows multiple conversion strategies
//    - Follows single responsibility principle
//
// 3. MOCK DATA GENERATION:
//    - Deterministic algorithms for consistent demo results
//    - Realistic values for better user experience
//    - Easy to understand and modify
//    - Clearly marked as demo code
//
// 4. FIELD NAMING STRATEGY:
//    - Match API field names exactly in model
//    - Transform to business names in entity conversion
//    - Clear separation between external and internal naming
//    - Easier to debug API issues
//
// WHAT HAPPENS NEXT:
// ================
// 1. Repository implementation uses this model for API responses
// 2. Models are converted to entities before returning to use cases
// 3. Domain layer never sees external data formats
// 4. Business logic remains pure and focused
