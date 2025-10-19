import 'package:flutter/material.dart';
import '../../data/transaction_model.dart';

class TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<Transaction> onEdit;
  final ValueChanged<String> onDetails;

  const TransactionRow({
    super.key,
    required this.transaction,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(
          transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.isIncome ? Colors.green : Colors.red,
        ),
        title: Text(transaction.title),
        subtitle: Text(
          '${transaction.category} • ${transaction.createdAt.day}.${transaction.createdAt.month}.${transaction.createdAt.year}',
        ),
        trailing: Text(
          '${transaction.isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)} ₽',
          style: TextStyle(
            color: transaction.isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => onDetails(transaction.id),
        onLongPress: () => _showOptions(context),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Редактировать'),
            onTap: () {
              Navigator.pop(context);
              onEdit(transaction);
            },
          ),
          ListTile(
            leading: Icon(
              transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: transaction.isIncome ? Colors.red : Colors.green,
            ),
            title: Text(
                transaction.isIncome ? 'Сделать расходом' : 'Сделать доходом'),
            onTap: () {
              Navigator.pop(context);
              onToggle(transaction.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Удалить', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              onDelete(transaction.id);
            },
          ),
        ],
      ),
    );
  }
}