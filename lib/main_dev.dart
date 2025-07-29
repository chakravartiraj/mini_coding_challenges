import 'package:flutter/material.dart';
import 'package:mini_coding_challenges/core/di/injection.dart';
import 'package:mini_coding_challenges/features/transactions_bloc/presentation/pages/transaction_list_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'dev'));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.environment, super.key});

  final String environment;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mini Coding Challenges (DEV)',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      useMaterial3: true,
    ),
    home: const TransactionListPage(),
  );
}
