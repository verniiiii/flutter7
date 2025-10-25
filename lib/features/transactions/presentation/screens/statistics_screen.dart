import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../data/transaction_model.dart';
import '../../../../core/constants/categories.dart'; // Правильный импорт


class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // В реальном приложении здесь бы получали транзакции из состояния
    final transactions = [
      Transaction(
        id: '1',
        title: 'Зарплата',
        description: '',
        amount: 50000,
        createdAt: DateTime.now(),
        type: TransactionType.income,
        category: 'Зарплата',
      ),
      Transaction(
        id: '2',
        title: 'Продукты',
        description: '',
        amount: 15000,
        createdAt: DateTime.now(),
        type: TransactionType.expense,
        category: 'Продукты',
      ),
    ];

    Map<String, double> _getCategoryStats(TransactionType type) {
      final filtered = transactions.where((t) => t.type == type).toList();
      final grouped = groupBy(filtered, (t) => t.category);

      return grouped.map((category, transactions) => MapEntry(
        category,
        transactions.fold(0.0, (sum, t) => sum + t.amount),
      ));
    }

    double _getTotal(TransactionType type) {
      return transactions
          .where((t) => t.type == type)
          .fold(0.0, (sum, t) => sum + t.amount);
    }

    final incomeStats = _getCategoryStats(TransactionType.income);
    final expenseStats = _getCategoryStats(TransactionType.expense);
    final totalIncome = _getTotal(TransactionType.income);
    final totalExpenses = _getTotal(TransactionType.expense);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // ВЕРТИКАЛЬНЫЙ ВОЗВРАТ

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Сводка
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Общая статистика',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Доходы', '${totalIncome.toStringAsFixed(2)} ₽', Colors.green),
                        _buildStatItem('Расходы', '${totalExpenses.toStringAsFixed(2)} ₽', Colors.red),
                        _buildStatItem('Баланс', '${(totalIncome - totalExpenses).toStringAsFixed(2)} ₽',
                            (totalIncome - totalExpenses) >= 0 ? Colors.green : Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Статистика по доходам
            _buildCategorySection('Доходы по категориям', incomeStats, totalIncome, Colors.green),
            const SizedBox(height: 20),

            // Статистика по расходам
            _buildCategorySection('Расходы по категориям', expenseStats, totalExpenses, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String title, Map<String, double> stats, double total, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            ...stats.entries.map((entry) => _buildCategoryRow(
              entry.key,
              entry.value,
              total,
              color,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, double amount, double total, Color color) {
    final percentage = total > 0 ? (amount / total * 100) : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(category),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${amount.toStringAsFixed(2)} ₽\n${percentage.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}