import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/transaction_list.dart';
import '../../data/transaction_model.dart';
import '../../../../core/constants/categories.dart';
import 'transaction_form_screen.dart';
import 'edit_transaction_screen.dart';
import 'statistics_screen.dart';
import '../../../../features/profile/presentation/screens/profile_screen.dart';


class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Зарплата',
      description: 'Зарплата за январь',
      amount: 50000,
      createdAt: DateTime.now(),
      type: TransactionType.income,
      category: 'Зарплата',
    ),
    Transaction(
      id: '2',
      title: 'Продукты',
      description: 'Покупки в супермаркете',
      amount: 3500,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      category: 'Продукты',
    ),
  ];

  void _addTransaction() {
    context.push('/add');
  }

  void _toggleTransaction(String id) {
    setState(() {
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        final transaction = _transactions[index];
        _transactions[index] = transaction.copyWith(
          type: transaction.isExpense ? TransactionType.income : TransactionType.expense,
        );
      }
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((t) => t.id == id);
    });
  }

  // Код из transactions_list_screen.dart
  void _editTransaction(Transaction transaction) {
    context.push('/edit/${transaction.id}', extra: transaction);
  }

  void _showTransactionDetails(String transactionId) {
    // ГОРИЗОНТАЛЬНАЯ НАВИГАЦИЯ - маршрутизированная (замена текущего экрана)
    context.pushReplacement('/details?id=$transactionId');

  }


  // Код из transactions_list_screen.dart
  void _showStatistics() {
    context.push('/statistics');
  }

  void _showProfile() {
    context.push('/profile');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансовый Трекер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatistics,
            tooltip: 'Статистика',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showProfile,
            tooltip: 'Профиль',
          ),
        ],
      ),
      body: TransactionList(
        transactions: _transactions,
        onToggle: _toggleTransaction,
        onDelete: _deleteTransaction,
        onEdit: _editTransaction,
        onDetails: _showTransactionDetails,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}