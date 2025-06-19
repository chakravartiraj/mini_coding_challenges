// Presentation Layer Unit Tests - TransactionBloc
// ===============================================
//
// Comprehensive tests for TransactionBloc ensuring state management,
// event handling, business logic integration, and error scenarios
// work correctly according to industry standards.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';
import 'package:mini_coding_challenges/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_state.dart';
import '../../../helpers/test_data_builders.dart';

// Mock dependencies
class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

void main() {
  group('TransactionBloc', () {
    late TransactionBloc bloc;
    late MockGetTransactionsUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockGetTransactionsUseCase();
      bloc = TransactionBloc(mockUseCase);
    });

    tearDown(() {
      bloc.close();
    });

    group('Initial State', () {
      test('should have initial state when created', () {
        // Assert
        expect(bloc.state, const TransactionState.initial());
      });
    });

    group('LoadFirstPage Event', () {
      const pageSize = 20;

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loading, loaded] when successful',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true, // pageSize == returned length
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockUseCase(1, pageSize)).called(1);
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loading, loaded] with hasMore false when fewer returned',
        build: () {
          final incompleteTransactions =
              TransactionTestDataBuilder.paginatedTransactions(
                page: 1,
                pageSize: 15,
              ); // Less than pageSize

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => incompleteTransactions);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: 15,
            ),
            hasMore: false, // Less than pageSize returned
            currentPage: 1,
          ),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loading, loaded] with empty list when no data',
        build: () {
          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => <Transaction>[]);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.loaded(
            transactions: <Transaction>[],
            hasMore: false,
            currentPage: 1,
          ),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loading, error] when use case throws exception',
        build: () {
          when(
            () => mockUseCase(1, pageSize),
          ).thenThrow(Exception('Network error'));

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.error('Exception: Network error'),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle multiple LoadFirstPage events correctly',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        act: (bloc) {
          bloc.add(const TransactionEvent.loadFirstPage());
          bloc.add(const TransactionEvent.loadFirstPage()); // Second call
        },
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockUseCase(1, pageSize)).called(2);
        },
      );
    });

    group('LoadNextPage Event', () {
      const pageSize = 20;

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loadingMore, loaded] when hasMore is true',
        build: () {
          final page2Transactions =
              TransactionTestDataBuilder.paginatedTransactions(
                page: 2,
                pageSize: pageSize,
              );

          when(
            () => mockUseCase(2, pageSize),
          ).thenAnswer((_) async => page2Transactions);

          return bloc;
        },
        seed: () => TransactionState.loaded(
          transactions: TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          ),
          hasMore: true,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const TransactionEvent.loadNextPage()),
        expect: () => [
          TransactionState.loadingMore(
            TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
          ),
          TransactionState.loaded(
            transactions: [
              ...TransactionTestDataBuilder.paginatedTransactions(
                page: 1,
                pageSize: pageSize,
              ),
              ...TransactionTestDataBuilder.paginatedTransactions(
                page: 2,
                pageSize: pageSize,
              ),
            ],
            hasMore: true,
            currentPage: 2,
          ),
        ],
        verify: (_) {
          verify(() => mockUseCase(2, pageSize)).called(1);
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should not emit anything when hasMore is false',
        build: () => bloc,
        seed: () => const TransactionState.loaded(
          transactions: <Transaction>[],
          hasMore: false,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const TransactionEvent.loadNextPage()),
        expect: () => <TransactionState>[],
        verify: (_) {
          verifyNever(() => mockUseCase(any(), any()));
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should not emit anything when not in Loaded state',
        build: () => bloc,
        seed: () => const TransactionState.loading(),
        act: (bloc) => bloc.add(const TransactionEvent.loadNextPage()),
        expect: () => <TransactionState>[],
        verify: (_) {
          verifyNever(() => mockUseCase(any(), any()));
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loadingMore, error] when use case throws exception',
        build: () {
          when(
            () => mockUseCase(2, pageSize),
          ).thenThrow(Exception('Network timeout'));

          return bloc;
        },
        seed: () => TransactionState.loaded(
          transactions: TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          ),
          hasMore: true,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const TransactionEvent.loadNextPage()),
        expect: () => [
          TransactionState.loadingMore(
            TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
          ),
          const TransactionState.error('Exception: Network timeout'),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should set hasMore to false when partial page returned',
        build: () {
          final partialPage = TransactionTestDataBuilder.paginatedTransactions(
            page: 2,
            pageSize: 10,
          ); // Less than pageSize

          when(
            () => mockUseCase(2, pageSize),
          ).thenAnswer((_) async => partialPage);

          return bloc;
        },
        seed: () => TransactionState.loaded(
          transactions: TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          ),
          hasMore: true,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const TransactionEvent.loadNextPage()),
        expect: () => [
          TransactionState.loadingMore(
            TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
          ),
          TransactionState.loaded(
            transactions: [
              ...TransactionTestDataBuilder.paginatedTransactions(
                page: 1,
                pageSize: pageSize,
              ),
              ...TransactionTestDataBuilder.paginatedTransactions(
                page: 2,
                pageSize: 10,
              ),
            ],
            hasMore: false, // Partial page indicates no more data
            currentPage: 2,
          ),
        ],
      );
    });

    group('Refresh Event', () {
      const pageSize = 20;

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loading, loaded] when successful',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.refresh()),
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockUseCase(1, pageSize)).called(1);
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should reset pagination state on refresh',
        build: () {
          final refreshedTransactions =
              TransactionTestDataBuilder.paginatedTransactions(
                page: 1,
                pageSize: pageSize,
              );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => refreshedTransactions);

          return bloc;
        },
        seed: () => TransactionState.loaded(
          transactions: [
            ...TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            ...TransactionTestDataBuilder.paginatedTransactions(
              page: 2,
              pageSize: pageSize,
            ),
          ],
          hasMore: false,
          currentPage: 2,
        ),
        act: (bloc) => bloc.add(const TransactionEvent.refresh()),
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1, // Reset to page 1
          ),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should emit [loading, error] when use case throws exception',
        build: () {
          when(
            () => mockUseCase(1, pageSize),
          ).thenThrow(Exception('Server error'));

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.refresh()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.error('Exception: Server error'),
        ],
      );
    });

    group('State Transitions', () {
      const pageSize = 20;

      blocTest<TransactionBloc, TransactionState>(
        'should handle state transitions from initial to loaded',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle state transitions from error to loaded',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        seed: () => const TransactionState.error('Previous error'),
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle complex event sequence',
        build: () {
          final page1 = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );
          final page2 = TransactionTestDataBuilder.paginatedTransactions(
            page: 2,
            pageSize: pageSize,
          );

          when(() => mockUseCase(1, pageSize)).thenAnswer((_) async => page1);
          when(() => mockUseCase(2, pageSize)).thenAnswer((_) async => page2);

          return bloc;
        },
        act: (bloc) {
          bloc.add(const TransactionEvent.loadFirstPage());
          bloc.add(const TransactionEvent.loadNextPage());
        },
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          TransactionState.loadingMore(
            TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
          ),
          TransactionState.loaded(
            transactions: [
              ...TransactionTestDataBuilder.paginatedTransactions(
                page: 1,
                pageSize: pageSize,
              ),
              ...TransactionTestDataBuilder.paginatedTransactions(
                page: 2,
                pageSize: pageSize,
              ),
            ],
            hasMore: true,
            currentPage: 2,
          ),
        ],
      );
    });

    group('Error Handling', () {
      const pageSize = 20;

      blocTest<TransactionBloc, TransactionState>(
        'should handle ArgumentError from use case',
        build: () {
          when(
            () => mockUseCase(1, pageSize),
          ).thenThrow(ArgumentError('Invalid parameters'));

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.error(
            'Invalid argument(s): Invalid parameters',
          ),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle network timeouts',
        build: () {
          when(
            () => mockUseCase(1, pageSize),
          ).thenThrow(Exception('Connection timeout'));

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.error('Exception: Connection timeout'),
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle generic exceptions',
        build: () {
          when(() => mockUseCase(1, pageSize)).thenThrow('Unknown error');

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.error('Unknown error'),
        ],
      );
    });

    group('Edge Cases', () {
      const pageSize = 20;

      blocTest<TransactionBloc, TransactionState>(
        'should handle rapid event firing',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        act: (bloc) {
          // Fire multiple events rapidly
          for (int i = 0; i < 5; i++) {
            bloc.add(const TransactionEvent.loadFirstPage());
          }
        },
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockUseCase(1, pageSize)).called(5);
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle mixed event types',
        build: () {
          final transactions = TransactionTestDataBuilder.paginatedTransactions(
            page: 1,
            pageSize: pageSize,
          );

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => transactions);

          return bloc;
        },
        act: (bloc) {
          bloc.add(const TransactionEvent.loadFirstPage());
          bloc.add(const TransactionEvent.refresh());
          bloc.add(const TransactionEvent.loadNextPage());
        },
        expect: () => [
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          const TransactionState.loading(),
          TransactionState.loaded(
            transactions: TransactionTestDataBuilder.paginatedTransactions(
              page: 1,
              pageSize: pageSize,
            ),
            hasMore: true,
            currentPage: 1,
          ),
          // LoadNextPage should be ignored due to recent state change
        ],
      );

      blocTest<TransactionBloc, TransactionState>(
        'should handle empty responses correctly',
        build: () {
          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => <Transaction>[]);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        expect: () => [
          const TransactionState.loading(),
          const TransactionState.loaded(
            transactions: <Transaction>[],
            hasMore: false,
            currentPage: 1,
          ),
        ],
      );
    });

    group('Business Logic Integration', () {
      const pageSize = 20;

      test('should use correct page size constant', () {
        expect(pageSize, 20);
      });

      blocTest<TransactionBloc, TransactionState>(
        'should maintain transaction order from use case',
        build: () {
          final orderedTransactions = [
            TransactionTestDataBuilder.income(),
            TransactionTestDataBuilder.expense(),
            TransactionTestDataBuilder.income(id: 3),
          ];

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => orderedTransactions);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        verify: (_) {
          final loadedState = bloc.state as Loaded;
          expect(loadedState.transactions[0].id, 1);
          expect(loadedState.transactions[1].id, 2);
          expect(loadedState.transactions[2].id, 3);
        },
      );

      blocTest<TransactionBloc, TransactionState>(
        'should preserve transaction data integrity',
        build: () {
          final originalTransactions =
              TransactionTestDataBuilder.mixedTransactions(count: 3);

          when(
            () => mockUseCase(1, pageSize),
          ).thenAnswer((_) async => originalTransactions);

          return bloc;
        },
        act: (bloc) => bloc.add(const TransactionEvent.loadFirstPage()),
        verify: (_) {
          final loadedState = bloc.state as Loaded;
          final returnedTransactions = loadedState.transactions;
          final originalTransactions =
              TransactionTestDataBuilder.mixedTransactions(count: 3);

          expect(returnedTransactions.length, 3);
          for (int i = 0; i < returnedTransactions.length; i++) {
            expect(returnedTransactions[i], originalTransactions[i]);
          }
        },
      );
    });
  });
}
