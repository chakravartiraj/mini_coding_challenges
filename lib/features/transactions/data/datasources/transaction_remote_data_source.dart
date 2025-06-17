import 'package:mini_coding_challenges/core/network/api_client.dart';
import 'package:mini_coding_challenges/features/transactions/data/models/transaction_response.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions(int page, int limit);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  TransactionRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<TransactionModel>> getTransactions(int page, int limit) =>
      _apiClient.getTransactions(page, limit);
}
