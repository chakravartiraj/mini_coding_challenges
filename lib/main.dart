import 'package:flutter/material.dart';
import 'package:mini_coding_challenges/core/di/injection.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/pages/transaction_list_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mini Coding Challenges',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const TransactionListPage(),
    debugShowCheckedModeBanner: false,
  );
}
