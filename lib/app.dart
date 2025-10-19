import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'features/transactions/state/transactions_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Финансовый трекер',
      theme: AppTheme.lightTheme,
      home: const TransactionsContainer(),
    );
  }
}