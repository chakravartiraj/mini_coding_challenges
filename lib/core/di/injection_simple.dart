import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mini_coding_challenges/core/network/api_client.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/data/datasources/transaction_remote_data_source.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/data/repositories/transaction_repository_impl.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/domain/repositories/transaction_repository.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/domain/usecases/get_transactions_usecase.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/presentation/bloc/transaction_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core
  getIt
    ..registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: 'https://jsonplaceholder.typicode.com',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
    )
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()))
    // Data Layer
    ..registerLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(getIt<TransactionRemoteDataSource>()),
    )
    // Domain Layer
    ..registerLazySingleton<GetTransactionsUseCase>(
      () => GetTransactionsUseCase(getIt<TransactionRepository>()),
    )
    // Presentation Layer
    ..registerFactory<TransactionBloc>(
      () => TransactionBloc(getIt<GetTransactionsUseCase>()),
    );
}
