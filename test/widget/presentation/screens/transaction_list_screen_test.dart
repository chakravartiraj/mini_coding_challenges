// Widget Tests for Transaction List Page
// ======================================
//
// This file contains comprehensive widget tests for the transaction list page,
// testing UI components, user interactions, and integration with BLoC states.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/pages/transaction_list_page.dart';

import '../../../helpers/test_data_builders.dart';

// Mock BLoC for isolated widget testing
class MockTransactionBloc extends Mock implements TransactionBloc {}

void main() {
  group('TransactionListPage Widget Tests', () {
    late MockTransactionBloc mockBloc;

    setUp(() {
      mockBloc = MockTransactionBloc();
    });

    // Helper function to create the widget under test
    Widget createWidgetUnderTest() => MaterialApp(
        home: BlocProvider<TransactionBloc>(
          create: (context) => mockBloc,
          child: const TransactionListPage(),
        ),
      );

    group('Initial State', () {
      testWidgets('should display app bar with correct title', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TransactionState.initial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Transactions'), findsOneWidget);
      });

      testWidgets('should display initial state message', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TransactionState.initial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Welcome! Tap to load transactions.'), findsOneWidget);
        expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      });

      testWidgets('should trigger LoadFirstPage when tapped', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TransactionState.initial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.byType(InkWell));

        // Assert
        verify(() => mockBloc.add(const LoadFirstPage())).called(1);
      });
    });

    group('Loading State', () {
      testWidgets('should display loading indicator', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TransactionState.loading());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading transactions...'), findsOneWidget);
      });
    });

    group('Loaded State', () {
      testWidgets('should display transaction list', (tester) async {
        // Arrange
        final testTransactions = [
          TransactionTestDataBuilder.income(title: 'Salary'),
          TransactionTestDataBuilder.expense(title: 'Groceries'),
        ];

        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: testTransactions,
            hasMore: true,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Salary'), findsOneWidget);
        expect(find.text('Groceries'), findsOneWidget);
      });

      testWidgets('should display formatted amounts correctly', (tester) async {
        // Arrange
        final testTransactions = [
          TransactionTestDataBuilder.income(amount: 1500.50),
          TransactionTestDataBuilder.expense(amount: 75.25),
        ];

        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: testTransactions,
            hasMore: false,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('+\$1500.50'), findsOneWidget);
        expect(find.text('-\$75.25'), findsOneWidget);
      });

      testWidgets('should display correct icons for transaction types', (
        tester,
      ) async {
        // Arrange
        final testTransactions = [
          TransactionTestDataBuilder.income(),
          TransactionTestDataBuilder.expense(),
        ];

        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: testTransactions,
            hasMore: false,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.arrow_downward), findsOneWidget); // Income
        expect(find.byIcon(Icons.arrow_upward), findsOneWidget); // Expense
      });

      testWidgets('should display load more button when hasMore is true', (
        tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: [TransactionTestDataBuilder.income()],
            hasMore: true,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Load More'), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('should trigger LoadNextPage when load more is tapped', (
        tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: [TransactionTestDataBuilder.income()],
            hasMore: true,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.text('Load More'));

        // Assert
        verify(() => mockBloc.add(const LoadNextPage())).called(1);
      });
    });

    group('Loading More State', () {
      testWidgets(
        'should display existing transactions and loading indicator',
        (tester) async {
          // Arrange
          final existingTransactions = [
            TransactionTestDataBuilder.income(title: 'Existing'),
          ];

          when(
            () => mockBloc.state,
          ).thenReturn(TransactionState.loadingMore(existingTransactions));

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.text('Existing'), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.text('Loading more...'), findsOneWidget);
        },
      );
    });

    group('Error State', () {
      testWidgets('should display error message with retry button', (
        tester,
      ) async {
        // Arrange
        const errorMessage = 'Network error occurred';
        when(
          () => mockBloc.state,
        ).thenReturn(const TransactionState.error(errorMessage));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Error: $errorMessage'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should trigger LoadFirstPage when retry is tapped', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockBloc.state,
        ).thenReturn(const TransactionState.error('Error'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.text('Retry'));

        // Assert
        verify(() => mockBloc.add(const LoadFirstPage())).called(1);
      });
    });

    group('Pull to Refresh', () {
      testWidgets('should trigger refresh when pulled down', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: [TransactionTestDataBuilder.income()],
            hasMore: false,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.fling(
          find.byType(RefreshIndicator),
          const Offset(0, 300),
          1000,
        );
        await tester.pump();

        // Assert
        verify(() => mockBloc.add(const Refresh())).called(1);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: [
              TransactionTestDataBuilder.income(
                title: 'Salary',
                amount: 1000,
              ),
            ],
            hasMore: false,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(
          find.bySemanticsLabel('Income transaction: Salary, +\$1000.00'),
          findsOneWidget,
        );
      });

      testWidgets('should support screen readers', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(const TransactionState.loading());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.bySemanticsLabel('Loading transactions'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty transaction list', (tester) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const TransactionState.loaded(
            transactions: [],
            hasMore: false,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('No transactions found'), findsOneWidget);
        expect(find.byIcon(Icons.inbox), findsOneWidget);
      });

      testWidgets('should handle very long transaction titles', (tester) async {
        // Arrange
        final longTitle = 'A' * 100; // Very long title
        when(() => mockBloc.state).thenReturn(
          TransactionState.loaded(
            transactions: [TransactionTestDataBuilder.income(title: longTitle)],
            hasMore: false,
            currentPage: 1,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.textContaining('A'), findsOneWidget);
      });
    });
  });
}
