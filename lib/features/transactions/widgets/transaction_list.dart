import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_row.dart';
import '../../../shared/widgets/empty_state.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<Transaction> onEdit;
  final double balance;
  final double totalIncome;
  final double totalExpenses;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const EmptyState(
        message: 'Нет транзакций\nДобавьте первую транзакцию',
        icon: Icons.account_balance_wallet,
      );
    }

    return Column(
      children: [
        // Карточка с общей статистикой
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Общий баланс',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${balance.toStringAsFixed(2)} ₽',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: balance >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Доходы',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '+${totalIncome.toStringAsFixed(2)} ₽',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Расходы',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '-${totalExpenses.toStringAsFixed(2)} ₽',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Заголовок списка
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'История транзакций',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                '${transactions.length} шт.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Список транзакций
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionRow(
                key: ValueKey(transaction.id),
                transaction: transaction,
                onToggle: onToggle,
                onDelete: onDelete,
                onEdit: onEdit,
              );
            },
          ),
        ),
      ],
    );
  }
}