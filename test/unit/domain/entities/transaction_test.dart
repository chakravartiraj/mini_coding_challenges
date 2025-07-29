// Domain Layer Unit Tests - Transaction Entity
// ============================================
//
// Comprehensive tests for the Transaction entity ensuring all business logic,
// data validation, and computed properties work correctly according to
// industry standards.

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/domain/entities/transaction.dart';
import '../../../helpers/test_data_builders.dart';

void main() {
  group('Transaction Entity', () {
    group('Constructor & Properties', () {
      test('should create transaction with valid data', () {
        // Arrange & Act
        final transaction = TransactionTestDataBuilder.income();

        // Assert
        expect(transaction.id, 1);
        expect(transaction.userId, 1);
        expect(transaction.title, 'Test Income');
        expect(transaction.description, 'Test income description');
        expect(transaction.amount, 100.0);
        expect(transaction.date, DateTime(2024));
        expect(transaction.type, TransactionType.income);
      });

      test('should create expense transaction', () {
        // Arrange & Act
        final transaction = TransactionTestDataBuilder.expense();

        // Assert
        expect(transaction.type, TransactionType.expense);
        expect(transaction.amount, 50.0);
        expect(transaction.title, 'Test Expense');
      });

      test('should handle edge case values', () {
        // Arrange & Act
        final transactions = TransactionTestDataBuilder.edgeCaseTransactions();

        // Assert
        expect(transactions.length, 8);

        // Zero amount
        expect(transactions[0].amount, 0.0);
        expect(transactions[0].type, TransactionType.income);

        // Large amount
        expect(transactions[1].amount, 999999.99);
        expect(transactions[1].type, TransactionType.expense);

        // Small amount
        expect(transactions[2].amount, 0.01);
        expect(transactions[2].type, TransactionType.income);

        // Future date
        expect(transactions[6].date, DateTime(2030, 12, 31));

        // Past date
        expect(transactions[7].date, DateTime(1990));
      });
    });

    group('Equality & Hash Code', () {
      test('should be equal when all properties match', () {
        // Arrange
        final transaction1 = TransactionTestDataBuilder.income();
        final transaction2 = TransactionTestDataBuilder.income();

        // Act & Assert
        expect(transaction1, equals(transaction2));
        expect(transaction1.hashCode, equals(transaction2.hashCode));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        final transaction1 = TransactionTestDataBuilder.income();
        final transaction2 = TransactionTestDataBuilder.income(id: 2);

        // Act & Assert
        expect(transaction1, isNot(equals(transaction2)));
        expect(transaction1.hashCode, isNot(equals(transaction2.hashCode)));
      });

      test('should not be equal when amounts differ', () {
        // Arrange
        final transaction1 = TransactionTestDataBuilder.income();
        final transaction2 = TransactionTestDataBuilder.income(amount: 200);

        // Act & Assert
        expect(transaction1, isNot(equals(transaction2)));
      });

      test('should not be equal when types differ', () {
        // Arrange
        final income = TransactionTestDataBuilder.income();
        final expense = TransactionTestDataBuilder.expense(id: 1);

        // Act & Assert
        expect(income, isNot(equals(expense)));
      });
    });

    group('Business Logic Properties', () {
      group('isIncome getter', () {
        test('should return true for income transactions', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income();

          // Act & Assert
          expect(transaction.isIncome, isTrue);
        });

        test('should return false for expense transactions', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.expense();

          // Act & Assert
          expect(transaction.isIncome, isFalse);
        });
      });

      group('isExpense getter', () {
        test('should return true for expense transactions', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.expense();

          // Act & Assert
          expect(transaction.isExpense, isTrue);
        });

        test('should return false for income transactions', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income();

          // Act & Assert
          expect(transaction.isExpense, isFalse);
        });
      });

      group('signedAmount getter', () {
        test('should return positive amount for income', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income();

          // Act
          final signedAmount = transaction.signedAmount;

          // Assert
          expect(signedAmount, 100.0);
        });

        test('should return negative amount for expense', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.expense();

          // Act
          final signedAmount = transaction.signedAmount;

          // Assert
          expect(signedAmount, -50.0);
        });

        test('should handle zero amounts correctly', () {
          // Arrange
          final incomeZero = TransactionTestDataBuilder.income(amount: 0);
          final expenseZero = TransactionTestDataBuilder.expense(amount: 0);

          // Act & Assert
          expect(incomeZero.signedAmount, 0.0);
          expect(expenseZero.signedAmount, -0.0);
        });

        test('should handle large amounts correctly', () {
          // Arrange
          final largeIncome = TransactionTestDataBuilder.income(
            amount: 999999.99,
          );
          final largeExpense = TransactionTestDataBuilder.expense(
            amount: 999999.99,
          );

          // Act & Assert
          expect(largeIncome.signedAmount, 999999.99);
          expect(largeExpense.signedAmount, -999999.99);
        });
      });

      group('formattedAmount getter', () {
        test('should format income amount with plus sign', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income();

          // Act
          final formatted = transaction.formattedAmount;

          // Assert
          expect(formatted, '+\$100.00');
        });

        test('should format expense amount with minus sign', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.expense();

          // Act
          final formatted = transaction.formattedAmount;

          // Assert
          expect(formatted, '-\$50.00');
        });

        test('should format zero amounts correctly', () {
          // Arrange
          final incomeZero = TransactionTestDataBuilder.income(amount: 0);
          final expenseZero = TransactionTestDataBuilder.expense(amount: 0);

          // Act & Assert
          expect(incomeZero.formattedAmount, '+\$0.00');
          expect(expenseZero.formattedAmount, '-\$0.00');
        });

        test('should format decimal amounts correctly', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income(amount: 123.45);

          // Act
          final formatted = transaction.formattedAmount;

          // Assert
          expect(formatted, '+\$123.45');
        });

        test('should format single decimal places correctly', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.expense(amount: 99.9);

          // Act
          final formatted = transaction.formattedAmount;

          // Assert
          expect(formatted, '-\$99.90');
        });

        test('should format large amounts correctly', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income(
            amount: 1234567.89,
          );

          // Act
          final formatted = transaction.formattedAmount;

          // Assert
          expect(formatted, '+\$1234567.89');
        });
      });

      group('formattedDate getter', () {
        test('should format date correctly', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income(
            date: DateTime(2024, 1, 15),
          );

          // Act
          final formatted = transaction.formattedDate;

          // Assert
          expect(formatted, '15/1/2024');
        });

        test('should format single digit dates correctly', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income(
            date: DateTime(2024, 3, 5),
          );

          // Act
          final formatted = transaction.formattedDate;

          // Assert
          expect(formatted, '5/3/2024');
        });

        test('should format double digit dates correctly', () {
          // Arrange
          final transaction = TransactionTestDataBuilder.income(
            date: DateTime(2024, 12, 31),
          );

          // Act
          final formatted = transaction.formattedDate;

          // Assert
          expect(formatted, '31/12/2024');
        });

        test('should handle edge case dates', () {
          // Arrange
          final oldTransaction = TransactionTestDataBuilder.income(
            date: DateTime(1990),
          );
          final futureTransaction = TransactionTestDataBuilder.income(
            date: DateTime(2030, 12, 31),
          );

          // Act & Assert
          expect(oldTransaction.formattedDate, '1/1/1990');
          expect(futureTransaction.formattedDate, '31/12/2030');
        });
      });
    });

    group('toString Implementation', () {
      test('should provide readable string representation', () {
        // Arrange
        final transaction = TransactionTestDataBuilder.income(
          
        );

        // Act
        final stringRepresentation = transaction.toString();

        // Assert
        expect(stringRepresentation, contains('Transaction'));
        expect(stringRepresentation, contains('id: 1'));
        expect(stringRepresentation, contains('title: Test Income'));
        expect(stringRepresentation, contains('amount: 100.0'));
        expect(stringRepresentation, contains('type: TransactionType.income'));
      });
    });

    group('Immutability', () {
      test('should be immutable - create new instance for modifications', () {
        // Arrange
        final original = TransactionTestDataBuilder.income(
          
        );

        // Act - Create new instance with modified amount
        final modified = TransactionTestDataBuilder.income(
          id: original.id,
          userId: original.userId,
          title: original.title,
          description: original.description,
          amount: 200, // Modified amount
          date: original.date,
        );

        // Assert
        expect(original.amount, 100.0); // Original unchanged
        expect(modified.amount, 200.0); // New instance modified
        expect(original.id, modified.id); // Other properties preserved
        expect(original, isNot(same(modified))); // Different instances
        expect(original, isNot(equals(modified))); // Different values
      });

      test('should create equal instances when same data provided', () {
        // Arrange
        final original = TransactionTestDataBuilder.income();

        // Act - Create identical instance
        final identical = TransactionTestDataBuilder.income();

        // Assert
        expect(identical, equals(original));
        expect(identical, isNot(same(original)));
      });
    });

    group('Data Validation', () {
      test('should handle negative IDs gracefully in tests', () {
        // Note: In production, validation might be at a higher layer
        // This test documents current behavior

        // Arrange & Act
        final transaction = TransactionTestDataBuilder.income(id: -1);

        // Assert - Entity itself doesn't validate, but we document it
        expect(transaction.id, -1);
      });

      test('should handle negative amounts for income', () {
        // Arrange & Act
        final transaction = TransactionTestDataBuilder.income(amount: -100);

        // Assert
        expect(transaction.amount, -100.0);
        expect(transaction.signedAmount, -100.0); // Still positive for income
        expect(transaction.formattedAmount, '+\$-100.00');
      });

      test('should handle very large amounts', () {
        // Arrange
        const largeAmount = 999999999999.99;

        // Act
        final transaction = TransactionTestDataBuilder.income(
          amount: largeAmount,
        );

        // Assert
        expect(transaction.amount, largeAmount);
        expect(transaction.signedAmount, largeAmount);
      });

      test('should handle very small positive amounts', () {
        // Arrange
        const smallAmount = 0.001;

        // Act
        final transaction = TransactionTestDataBuilder.income(
          amount: smallAmount,
        );

        // Assert
        expect(transaction.amount, smallAmount);
        expect(transaction.signedAmount, smallAmount);
        expect(transaction.formattedAmount, '+\$0.00'); // Rounded display
      });
    });

    group('Business Rules', () {
      test('should correctly identify transaction categories', () {
        // Arrange
        final income = TransactionTestDataBuilder.income();
        final expense = TransactionTestDataBuilder.expense();

        // Act & Assert
        expect(income.isIncome, isTrue);
        expect(income.isExpense, isFalse);
        expect(expense.isIncome, isFalse);
        expect(expense.isExpense, isTrue);
      });

      test('should calculate signed amounts for balance calculations', () {
        // Arrange
        final transactions = [
          TransactionTestDataBuilder.income(),
          TransactionTestDataBuilder.expense(amount: 30),
          TransactionTestDataBuilder.income(amount: 50),
          TransactionTestDataBuilder.expense(amount: 20),
        ];

        // Act
        final totalBalance = transactions
            .map((t) => t.signedAmount)
            .reduce((a, b) => a + b);

        // Assert
        expect(totalBalance, 100.0); // 100 + 50 - 30 - 20 = 100
      });

      test('should maintain transaction type integrity', () {
        // Arrange
        final income = TransactionTestDataBuilder.income();
        final expense = TransactionTestDataBuilder.expense();

        // Act & Assert
        expect(income.type, TransactionType.income);
        expect(expense.type, TransactionType.expense);

        // Verify computed properties align with type
        expect(income.isIncome, isTrue);
        expect(expense.isExpense, isTrue);
      });
    });
  });

  group('TransactionType Enum', () {
    test('should have correct values', () {
      // Act & Assert
      expect(TransactionType.values.length, 2);
      expect(TransactionType.values, contains(TransactionType.income));
      expect(TransactionType.values, contains(TransactionType.expense));
    });

    test('should have proper string representation', () {
      // Act & Assert
      expect(TransactionType.income.toString(), 'TransactionType.income');
      expect(TransactionType.expense.toString(), 'TransactionType.expense');
    });

    test('should be comparable', () {
      // Arrange
      const type1 = TransactionType.income;
      const type2 = TransactionType.income;
      const type3 = TransactionType.expense;

      // Act & Assert
      expect(type1, equals(type2));
      expect(type1, isNot(equals(type3)));
    });
  });
}
