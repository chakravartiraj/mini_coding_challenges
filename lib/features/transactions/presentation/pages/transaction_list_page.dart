import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mini_coding_challenges/core/di/injection.dart';
import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/widgets/error_widget.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/widgets/loading_indicator.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/widgets/transaction_list_item.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late final ScrollController _scrollController;
  late final TransactionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bloc = getIt<TransactionBloc>();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);

    // Load initial data
    _bloc.add(const TransactionEvent.loadFirstPage());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _bloc.add(const TransactionEvent.loadNextPage());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Transactions'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _bloc.add(const TransactionEvent.refresh()),
        ),
      ],
    ),
    body: BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) => state.when(
          initial: () =>
              const Center(child: Text('Ready to load transactions')),
          loading: () => const LoadingIndicator(),
          loadingMore: (transactions) => _buildTransactionList(
            transactions: transactions,
            isLoadingMore: true,
          ),
          loaded: (transactions, hasMore, currentPage) => _buildTransactionList(
            transactions: transactions,
            hasMore: hasMore,
          ),
          error: (message) => ErrorWidgetCustom(
            message: message,
            onRetry: () => _bloc.add(const TransactionEvent.loadFirstPage()),
          ),
        ),
      ),
    ),
  );

  Widget _buildTransactionList({
    required List<Transaction> transactions,
    bool isLoadingMore = false,
    bool hasMore = true,
  }) => RefreshIndicator(
    onRefresh: () async {
      _bloc.add(const TransactionEvent.refresh());
    },
    child: ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == transactions.length) {
          return const LoadingIndicator();
        }

        final transaction = transactions[index];
        return TransactionListItem(
          transaction: transaction,
          onTap: () => _showTransactionDetails(transaction),
        );
      },
    ),
  );

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Transaction Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              _buildDetailRow('ID', transaction.id.toString()),
              _buildDetailRow('Title', transaction.title),
              _buildDetailRow('Description', transaction.description),
              _buildDetailRow(
                'Amount',
                '\$${transaction.amount.toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                'Date',
                transaction.date.toString().split(' ')[0],
              ),
              _buildDetailRow(
                'Type',
                transaction.type.toString().split('.').last.toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
