import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({required this.transaction, super.key, this.onTap});
  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final amountPrefix = isIncome ? '+' : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: amountColor.withValues(alpha: 0.1),
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: amountColor,
          ),
        ),
        title: Text(
          transaction.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy').format(transaction.date),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: amountColor,
            fontSize: 16,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
