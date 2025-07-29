import 'package:flutter_test/flutter_test.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/domain/entities/transaction.dart';

void main() {
  group('Transaction Entity Tests', () {
    test('should create transaction with valid data', () {
      // Arrange
      final transaction = Transaction(
        id: 1,
        userId: 1,
        title: 'Test Transaction',
        description: 'Test Description',
        amount: 100,
        date: DateTime(2024),
        type: TransactionType.income,
      );

      // Assert
      expect(transaction.id, 1);
      expect(transaction.userId, 1);
      expect(transaction.title, 'Test Transaction');
      expect(transaction.description, 'Test Description');
      expect(transaction.amount, 100.0);
      expect(transaction.date, DateTime(2024));
      expect(transaction.type, TransactionType.income);
    });

    test('should have proper equality', () {
      // Arrange
      final transaction1 = Transaction(
        id: 1,
        userId: 1,
        title: 'Test Transaction',
        description: 'Test Description',
        amount: 100,
        date: DateTime(2024),
        type: TransactionType.income,
      );

      final transaction2 = Transaction(
        id: 1,
        userId: 1,
        title: 'Test Transaction',
        description: 'Test Description',
        amount: 100,
        date: DateTime(2024),
        type: TransactionType.income,
      );

      // Assert
      expect(transaction1, equals(transaction2));
      expect(transaction1.hashCode, equals(transaction2.hashCode));
    });

    test('should have different equality for different data', () {
      // Arrange
      final transaction1 = Transaction(
        id: 1,
        userId: 1,
        title: 'Test Transaction 1',
        description: 'Test Description 1',
        amount: 100,
        date: DateTime(2024),
        type: TransactionType.income,
      );

      final transaction2 = Transaction(
        id: 2,
        userId: 2,
        title: 'Test Transaction 2',
        description: 'Test Description 2',
        amount: 200,
        date: DateTime(2024, 1, 2),
        type: TransactionType.expense,
      );

      // Assert
      expect(transaction1, isNot(equals(transaction2)));
    });

    test('should correctly identify income transactions', () {
      // Arrange
      final incomeTransaction = Transaction(
        id: 1,
        userId: 1,
        title: 'Salary',
        description: 'Monthly salary',
        amount: 5000,
        date: DateTime(2024),
        type: TransactionType.income,
      );

      // Assert
      expect(incomeTransaction.isIncome, isTrue);
      expect(incomeTransaction.isExpense, isFalse);
      expect(incomeTransaction.signedAmount, 5000.0);
    });

    test('should correctly identify expense transactions', () {
      // Arrange
      final expenseTransaction = Transaction(
        id: 2,
        userId: 1,
        title: 'Groceries',
        description: 'Weekly grocery shopping',
        amount: 150,
        date: DateTime(2024, 1, 2),
        type: TransactionType.expense,
      );

      // Assert
      expect(expenseTransaction.isExpense, isTrue);
      expect(expenseTransaction.isIncome, isFalse);
      expect(expenseTransaction.signedAmount, -150.0);
    });

    test('should format amount correctly', () {
      // Arrange
      final transaction = Transaction(
        id: 1,
        userId: 1,
        title: 'Test',
        description: 'Test',
        amount: 1234.56,
        date: DateTime(2024),
        type: TransactionType.income,
      );

      // Assert
      expect(transaction.formattedAmount, '+\$1234.56');
    });
  });
}
