import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/transaction_model.dart';
import '../../../../core/constants/categories.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    // В реальном приложении здесь бы получали транзакцию по ID
    final transaction = Transaction(
      id: transactionId,
      title: 'Пример транзакции',
      description: 'Подробное описание транзакции',
      amount: 1500,
      createdAt: DateTime.now(),
      type: TransactionType.expense,
      category: 'Продукты',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали транзакции'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ГОРИЗОНТАЛЬНАЯ НАВИГАЦИЯ - возврат с заменой
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transaction.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Сумма:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${transaction.amount.toStringAsFixed(2)} ₽',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: transaction.isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Категория:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          transaction.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Тип:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          transaction.type.displayName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Дата:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${transaction.createdAt.day}.${transaction.createdAt.month}.${transaction.createdAt.year}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Демонстрация навигации назад
                  context.pop();
                },
                child: const Text('Назад (Pop)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}