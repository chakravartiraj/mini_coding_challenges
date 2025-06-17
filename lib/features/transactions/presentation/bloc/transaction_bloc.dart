import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_coding_challenges/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this._getTransactionsUseCase)
    : super(const TransactionState.initial()) {
    on<LoadFirstPage>(_onLoadFirstPage);
    on<LoadNextPage>(_onLoadNextPage);
    on<Refresh>(_onRefresh);
  }
  final GetTransactionsUseCase _getTransactionsUseCase;

  static const int _pageSize = 20;

  Future<void> _onLoadFirstPage(
    LoadFirstPage event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());

    try {
      final transactions = await _getTransactionsUseCase(1, _pageSize);

      emit(
        TransactionState.loaded(
          transactions: transactions,
          hasMore: transactions.length == _pageSize,
          currentPage: 1,
        ),
      );
    } catch (error) {
      emit(TransactionState.error(error.toString()));
    }
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<TransactionState> emit,
  ) async {
    final currentState = state;

    if (currentState is Loaded && currentState.hasMore) {
      emit(TransactionState.loadingMore(currentState.transactions));

      try {
        final nextPage = currentState.currentPage + 1;
        final newTransactions = await _getTransactionsUseCase(
          nextPage,
          _pageSize,
        );

        final allTransactions = [
          ...currentState.transactions,
          ...newTransactions,
        ];

        emit(
          TransactionState.loaded(
            transactions: allTransactions,
            hasMore: newTransactions.length == _pageSize,
            currentPage: nextPage,
          ),
        );
      } catch (error) {
        emit(TransactionState.error(error.toString()));
      }
    }
  }

  Future<void> _onRefresh(Refresh event, Emitter<TransactionState> emit) async {
    emit(const TransactionState.loading());

    try {
      final transactions = await _getTransactionsUseCase(1, _pageSize);

      emit(
        TransactionState.loaded(
          transactions: transactions,
          hasMore: transactions.length == _pageSize,
          currentPage: 1,
        ),
      );
    } catch (error) {
      emit(TransactionState.error(error.toString()));
    }
  }
}
