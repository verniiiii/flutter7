import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/search_transactions.dart';

class TransactionsListScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<Transaction> onEdit;
  final double balance;
  final double totalIncome;
  final double totalExpenses;
  final VoidCallback onShowStatistics;
  final ValueChanged<List<Transaction>> onSearchResults;
  final bool isSearching;
  final VoidCallback onClearSearch;

  const TransactionsListScreen({
    super.key,
    required this.transactions,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.onShowStatistics,
    required this.onSearchResults,
    required this.isSearching,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансовый трекер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: onShowStatistics,
            tooltip: 'Статистика',
          ),
          IconButton(
            icon: const Icon(Icons.add_chart),
            onPressed: onAdd,
            tooltip: 'Добавить транзакцию',
          ),
        ],
      ),
      body: Column(
        children: [
          SearchTransactions(
            transactions: transactions,
            onSearchResults: onSearchResults,
          ),
          if (isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Результаты поиска: ${transactions.length} транзакций',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onClearSearch,
                    child: const Text('Очистить поиск'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TransactionList(
              transactions: transactions,
              onToggle: onToggle,
              onDelete: onDelete,
              onEdit: onEdit,
              balance: balance,
              totalIncome: totalIncome,
              totalExpenses: totalExpenses,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}