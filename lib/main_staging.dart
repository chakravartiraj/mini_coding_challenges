import 'package:flutter/material.dart';
import 'package:mini_coding_challenges/core/di/injection.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/pages/transaction_list_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'staging'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.environment});

  final String environment;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mini Coding Challenges (STAGING)',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      useMaterial3: true,
    ),
    home: const TransactionListPage(),
    debugShowCheckedModeBanner: true,
  );
}
