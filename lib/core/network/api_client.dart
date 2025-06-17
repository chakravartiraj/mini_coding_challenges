import 'package:dio/dio.dart';
import 'package:mini_coding_challenges/features/transactions/data/models/transaction_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/posts')
  Future<List<TransactionModel>> getTransactions(
    @Query('_page') int page,
    @Query('_limit') int limit,
  );
}
