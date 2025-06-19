// Widget Tests for Transaction List Item
// =====================================
//
// This file contains comprehensive widget tests for the transaction list item
// widget, testing UI rendering and user interactions.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/widgets/transaction_list_item.dart';

import '../../../helpers/test_data_builders.dart';

void main() {
  group('TransactionListItem Widget Tests', () {
    // Helper function to create the widget under test
    Widget createWidgetUnderTest({required Transaction transaction}) =>
        MaterialApp(
          home: Scaffold(body: TransactionListItem(transaction: transaction)),
        );

    group('Income Transaction Display', () {
      testWidgets('should display income transaction correctly', (
        tester,
      ) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(
          title: 'Freelance Payment',
          description: 'Payment from client ABC',
          amount: 1500.50,
        );

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.text('Freelance Payment'), findsOneWidget);
        expect(find.text('Payment from client ABC'), findsOneWidget);
        expect(find.text('+\$1500.50'), findsOneWidget);
      });

      testWidgets('should display income icon correctly', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income();

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      });

      testWidgets('should use green color for income amounts', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income();

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        final amountText = tester.widget<Text>(find.text('+\$100.00'));
        expect(amountText.style?.color, Colors.green);
      });
    });

    group('Expense Transaction Display', () {
      testWidgets('should display expense transaction correctly', (
        tester,
      ) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.expense(
          title: 'Grocery Shopping',
          description: 'Weekly groceries at SuperMart',
          amount: 89.75,
        );

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.text('Grocery Shopping'), findsOneWidget);
        expect(find.text('Weekly groceries at SuperMart'), findsOneWidget);
        expect(find.text('-\$89.75'), findsOneWidget);
      });

      testWidgets('should display expense icon correctly', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.expense();

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      });

      testWidgets('should use red color for expense amounts', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.expense();

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        final amountText = tester.widget<Text>(find.text('-\$50.00'));
        expect(amountText.style?.color, Colors.red);
      });
    });

    group('Date Display', () {
      testWidgets('should format and display date correctly', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(
          date: DateTime(2024, 3, 15),
        );

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.text('Mar 15, 2024'), findsOneWidget);
      });
    });

    group('Layout and Visual Structure', () {
      testWidgets('should have proper card structure', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income();

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should have leading icon', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income();

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.leading, isNotNull);
      });

      testWidgets('should have trailing amount', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(amount: 200);

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.trailing, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long titles gracefully', (tester) async {
        // Arrange
        const longTitle =
            'This is a very long transaction title that might '
            'overflow and we need to ensure it displays properly';
        final transaction = TransactionTestDataBuilder.income(title: longTitle);

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.textContaining('This is a very long'), findsOneWidget);
      });

      testWidgets('should handle empty description', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(description: '');

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert - Should not crash and should display title
        expect(find.text('Test Income'), findsOneWidget);
      });

      testWidgets('should handle zero amount', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(amount: 0);

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.text('+\$0.00'), findsOneWidget);
      });

      testWidgets('should handle decimal amounts correctly', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.expense(amount: 12.99);

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.text('-\$12.99'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper card structure for accessibility', (
        tester,
      ) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(
          title: 'Salary',
          amount: 2500,
        );

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('Salary'), findsOneWidget);
        expect(find.text('+\$2500.00'), findsOneWidget);
      });

      testWidgets('should be tappable for screen readers', (tester) async {
        // Arrange
        final transaction = TransactionTestDataBuilder.expense(
          title: 'Gas',
          amount: 45,
        );

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(transaction: transaction),
        );

        // Assert
        final listTile = find.byType(ListTile);
        expect(listTile, findsOneWidget);

        // Verify the ListTile can be tapped
        await tester.tap(listTile);
        await tester.pump();

        // Should not crash
        expect(find.byType(ListTile), findsOneWidget);
      });
    });
  });
}
