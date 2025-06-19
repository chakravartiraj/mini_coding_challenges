// Domain Layer Unit Tests - GetTransactionsUseCase
// ================================================
//
// Comprehensive tests for the GetTransactionsUseCase ensuring business logic,
// validation, error handling, and repository interaction work correctly.

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';
import 'package:mini_coding_challenges/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:mini_coding_challenges/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_data_builders.dart';

// Mock repository for testing
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('GetTransactionsUseCase', () {
    late GetTransactionsUseCase useCase;
    late MockTransactionRepository mockRepository;

    setUp(() {
      mockRepository = MockTransactionRepository();
      useCase = GetTransactionsUseCase(mockRepository);
    });

    group('Constructor', () {
      test('should initialize with repository dependency', () {
        // Arrange & Act
        final testUseCase = GetTransactionsUseCase(mockRepository);

        // Assert
        expect(testUseCase, isNotNull);
      });
    });

    group('Business Logic Validation', () {
      group('Page Parameter Validation', () {
        test('should throw ArgumentError when page is zero', () async {
          // Arrange
          const invalidPage = 0;
          const validLimit = 20;

          // Act & Assert
          expect(
            () => useCase(invalidPage, validLimit),
            throwsA(
              predicate<ArgumentError>(
                (e) => e.message == 'Page number must be greater than 0',
              ),
            ),
          );
        });

        test('should throw ArgumentError when page is negative', () async {
          // Arrange
          const invalidPage = -1;
          const validLimit = 20;

          // Act & Assert
          expect(
            () => useCase(invalidPage, validLimit),
            throwsA(
              predicate<ArgumentError>(
                (e) => e.message == 'Page number must be greater than 0',
              ),
            ),
          );
        });

        test('should accept positive page numbers', () async {
          // Arrange
          const validPage = 1;
          const validLimit = 20;
          final expectedTransactions =
              TransactionTestDataBuilder.paginatedTransactions(
                page: validPage,
                pageSize: validLimit,
              );

          when(
            () => mockRepository.getTransactions(validPage, validLimit),
          ).thenAnswer((_) async => expectedTransactions);

          // Act
          final result = await useCase(validPage, validLimit);

          // Assert
          expect(result, expectedTransactions);
          verify(
            () => mockRepository.getTransactions(validPage, validLimit),
          ).called(1);
        });
      });

      group('Limit Parameter Validation', () {
        test('should throw ArgumentError when limit is zero', () async {
          // Arrange
          const validPage = 1;
          const invalidLimit = 0;

          // Act & Assert
          expect(
            () => useCase(validPage, invalidLimit),
            throwsA(
              predicate<ArgumentError>(
                (e) => e.message == 'Limit must be greater than 0',
              ),
            ),
          );
        });

        test('should throw ArgumentError when limit is negative', () async {
          // Arrange
          const validPage = 1;
          const invalidLimit = -5;

          // Act & Assert
          expect(
            () => useCase(validPage, invalidLimit),
            throwsA(
              predicate<ArgumentError>(
                (e) => e.message == 'Limit must be greater than 0',
              ),
            ),
          );
        });

        test('should throw ArgumentError when limit exceeds maximum', () async {
          // Arrange
          const validPage = 1;
          const invalidLimit = 101; // Exceeds max of 100

          // Act & Assert
          expect(
            () => useCase(validPage, invalidLimit),
            throwsA(
              predicate<ArgumentError>(
                (e) =>
                    e.message ==
                    'Limit too large, maximum is 100 transactions per page',
              ),
            ),
          );
        });

        test('should accept valid limit values', () async {
          // Arrange
          const validPage = 1;
          const validLimit = 50;
          final expectedTransactions =
              TransactionTestDataBuilder.paginatedTransactions(
                page: validPage,
                pageSize: validLimit,
              );

          when(
            () => mockRepository.getTransactions(validPage, validLimit),
          ).thenAnswer((_) async => expectedTransactions);

          // Act
          final result = await useCase(validPage, validLimit);

          // Assert
          expect(result, expectedTransactions);
        });

        test('should accept maximum limit value', () async {
          // Arrange
          const validPage = 1;
          const maxLimit = 100;
          final expectedTransactions =
              TransactionTestDataBuilder.paginatedTransactions(
                page: validPage,
                pageSize: maxLimit,
              );

          when(
            () => mockRepository.getTransactions(validPage, maxLimit),
          ).thenAnswer((_) async => expectedTransactions);

          // Act
          final result = await useCase(validPage, maxLimit);

          // Assert
          expect(result, expectedTransactions);
        });
      });
    });

    group('Repository Interaction', () {
      test('should call repository with correct parameters', () async {
        // Arrange
        const page = 2;
        const limit = 15;
        final expectedTransactions =
            TransactionTestDataBuilder.paginatedTransactions(
              page: page,
              pageSize: limit,
            );

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => expectedTransactions);

        // Act
        await useCase(page, limit);

        // Assert
        verify(() => mockRepository.getTransactions(page, limit)).called(1);
      });

      test('should return transactions from repository', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final expectedTransactions = [
          TransactionTestDataBuilder.income(),
          TransactionTestDataBuilder.expense(),
          TransactionTestDataBuilder.income(id: 3),
        ];

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => expectedTransactions);

        // Act
        final result = await useCase(page, limit);

        // Assert
        expect(result, expectedTransactions);
        expect(result.length, 3);
        expect(result[0].id, 1);
        expect(result[1].id, 2);
        expect(result[2].id, 3);
      });

      test('should return empty list when repository returns empty', () async {
        // Arrange
        const page = 5;
        const limit = 20;
        final emptyList = <Transaction>[];

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => emptyList);

        // Act
        final result = await useCase(page, limit);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle large page numbers', () async {
        // Arrange
        const largePage = 999;
        const limit = 20;
        final expectedTransactions =
            TransactionTestDataBuilder.paginatedTransactions(
              page: largePage,
              pageSize: limit,
            );

        when(
          () => mockRepository.getTransactions(largePage, limit),
        ).thenAnswer((_) async => expectedTransactions);

        // Act
        final result = await useCase(largePage, limit);

        // Assert
        expect(result, expectedTransactions);
        verify(
          () => mockRepository.getTransactions(largePage, limit),
        ).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate repository exceptions', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final exception = Exception('Network error');

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenThrow(exception);

        // Act & Assert
        expect(() => useCase(page, limit), throwsA(isA<Exception>()));
      });

      test('should propagate specific error types', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final timeoutException = Exception('Request timeout');

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenThrow(timeoutException);

        // Act & Assert
        expect(
          () => useCase(page, limit),
          throwsA(
            predicate<Exception>(
              (e) => e.toString().contains('Request timeout'),
            ),
          ),
        );
      });

      test('should not catch validation errors from business logic', () async {
        // Arrange
        const invalidPage = -1;
        const validLimit = 20;

        // Act & Assert - Should throw immediately, not call repository
        expect(
          () => useCase(invalidPage, validLimit),
          throwsA(isA<ArgumentError>()),
        );

        verifyNever(() => mockRepository.getTransactions(any(), any()));
      });
    });

    group('Edge Cases', () {
      test('should handle minimum valid parameters', () async {
        // Arrange
        const minPage = 1;
        const minLimit = 1;
        final singleTransaction = [TransactionTestDataBuilder.income()];

        when(
          () => mockRepository.getTransactions(minPage, minLimit),
        ).thenAnswer((_) async => singleTransaction);

        // Act
        final result = await useCase(minPage, minLimit);

        // Assert
        expect(result, singleTransaction);
        expect(result.length, 1);
      });

      test('should handle maximum valid parameters', () async {
        // Arrange
        const maxPage = 999999;
        const maxLimit = 100;
        final maxTransactions =
            TransactionTestDataBuilder.paginatedTransactions(
              page: maxPage,
              pageSize: maxLimit,
            );

        when(
          () => mockRepository.getTransactions(maxPage, maxLimit),
        ).thenAnswer((_) async => maxTransactions);

        // Act
        final result = await useCase(maxPage, maxLimit);

        // Assert
        expect(result, maxTransactions);
        expect(result.length, maxLimit);
      });

      test('should handle repository returning null-like responses', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final emptyList = <Transaction>[];

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => emptyList);

        // Act
        final result = await useCase(page, limit);

        // Assert
        expect(result, isNotNull);
        expect(result, isEmpty);
      });
    });

    group('Async Behavior', () {
      test('should handle async repository calls correctly', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final expectedTransactions =
            TransactionTestDataBuilder.paginatedTransactions(
              page: page,
              pageSize: limit,
            );

        when(() => mockRepository.getTransactions(page, limit)).thenAnswer((
          _,
        ) async {
          await TestUtils.shortDelay(const Duration(milliseconds: 100));
          return expectedTransactions;
        });

        // Act
        final result = await useCase(page, limit);

        // Assert
        expect(result, expectedTransactions);
      });

      test('should handle multiple concurrent calls', () async {
        // Arrange
        const page1 = 1;
        const page2 = 2;
        const limit = 20;
        final transactions1 = TransactionTestDataBuilder.paginatedTransactions(
          page: page1,
          pageSize: limit,
        );
        final transactions2 = TransactionTestDataBuilder.paginatedTransactions(
          page: page2,
          pageSize: limit,
        );

        when(
          () => mockRepository.getTransactions(page1, limit),
        ).thenAnswer((_) async => transactions1);
        when(
          () => mockRepository.getTransactions(page2, limit),
        ).thenAnswer((_) async => transactions2);

        // Act
        final results = await Future.wait([
          useCase(page1, limit),
          useCase(page2, limit),
        ]);

        // Assert
        expect(results[0], transactions1);
        expect(results[1], transactions2);
        verify(() => mockRepository.getTransactions(page1, limit)).called(1);
        verify(() => mockRepository.getTransactions(page2, limit)).called(1);
      });
    });

    group('Business Rules Validation', () {
      test(
        'should validate business rules before calling repository',
        () async {
          // Arrange
          const invalidPage = 0;
          const validLimit = 20;

          // Act & Assert - Should fail validation before repository call
          expect(
            () => useCase(invalidPage, validLimit),
            throwsA(isA<ArgumentError>()),
          );

          // Verify repository was never called
          verifyNever(() => mockRepository.getTransactions(any(), any()));
        },
      );

      test('should validate all parameters together', () async {
        // Arrange
        const invalidPage = -1;
        const invalidLimit = -5;

        // Act & Assert - Should fail on first validation (page)
        expect(
          () => useCase(invalidPage, invalidLimit),
          throwsA(
            predicate<ArgumentError>(
              (e) => e.message == 'Page number must be greater than 0',
            ),
          ),
        );
      });

      test('should apply business logic consistently', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final mixedTransactions =
            TransactionTestDataBuilder.mixedTransactions();

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => mixedTransactions);

        // Act
        final result = await useCase(page, limit);

        // Assert - Business logic should pass through repository data unchanged
        expect(result, mixedTransactions);
        expect(result.every(TestUtils.isValidTransaction), isTrue);
      });
    });

    group('Performance', () {
      test('should not perform unnecessary operations', () async {
        // Arrange
        const page = 1;
        const limit = 1;
        final singleTransaction = [TransactionTestDataBuilder.income()];

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => singleTransaction);

        // Act
        final result = await useCase(page, limit);

        // Assert
        expect(result, singleTransaction);
        verify(() => mockRepository.getTransactions(page, limit)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle rapid successive calls', () async {
        // Arrange
        const page = 1;
        const limit = 20;
        final expectedTransactions =
            TransactionTestDataBuilder.paginatedTransactions(
              page: page,
              pageSize: limit,
            );

        when(
          () => mockRepository.getTransactions(page, limit),
        ).thenAnswer((_) async => expectedTransactions);

        // Act - Make multiple rapid calls
        final futures = List.generate(5, (_) => useCase(page, limit));
        final results = await Future.wait(futures);

        // Assert - All calls should succeed
        expect(results.length, 5);
        for (final result in results) {
          expect(result, expectedTransactions);
        }

        // Verify repository was called for each request
        verify(() => mockRepository.getTransactions(page, limit)).called(5);
      });
    });
  });
}
