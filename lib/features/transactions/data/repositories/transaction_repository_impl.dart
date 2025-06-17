import 'package:mini_coding_challenges/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:mini_coding_challenges/features/transactions/data/models/transaction_response.dart';
import 'package:mini_coding_challenges/features/transactions/domain/entities/transaction.dart';
import 'package:mini_coding_challenges/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._remoteDataSource);
  final TransactionRemoteDataSource _remoteDataSource;

  @override
  Future<List<Transaction>> getTransactions(int page, int limit) async {
    final models = await _remoteDataSource.getTransactions(page, limit);
    return models.map((model) => model.toEntity()).toList();
  }
}
