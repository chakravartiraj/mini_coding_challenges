# Environment Configuration Files
# ===============================

# Development Environment
lib/main_dev.dart:
```dart
import 'package:flutter/material.dart';
import 'package:mini_coding_challenges/core/di/injection.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/pages/transaction_list_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'dev'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.environment});
  
  final String environment;

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Mini Coding Challenges (DEV)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const TransactionListPage(),
      debugShowCheckedModeBanner: true,
    );
}
```

# Staging Environment  
lib/main_staging.dart:
```dart
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
```

# Production Environment
lib/main_production.dart:
```dart
import 'package:flutter/material.dart';
import 'package:mini_coding_challenges/core/di/injection.dart';
import 'package:mini_coding_challenges/features/transactions/presentation/pages/transaction_list_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp(environment: 'production'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.environment});
  
  final String environment;

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
```
