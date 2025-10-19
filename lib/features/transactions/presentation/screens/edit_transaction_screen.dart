import 'package:flutter/material.dart';
import '../../data/transaction_model.dart';
import '../../../../core/constants/categories.dart'; // Правильный импорт

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;
  final void Function(Transaction) onUpdate;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
    required this.onUpdate,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  late TransactionType _type;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.transaction.title;
    _descriptionController.text = widget.transaction.description;
    _amountController.text = widget.transaction.amount.toStringAsFixed(2);
    _type = widget.transaction.type as TransactionType;
    _selectedCategory = widget.transaction.category;
  }

  void _submit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (title.isEmpty || amount <= 0) {
      _showError('Заполните название и сумму (больше 0)');
      return;
    }

    final updatedTransaction = widget.transaction.copyWith(
      title: title,
      description: description,
      amount: amount,
      type: _type,
      category: _selectedCategory,
    );

    widget.onUpdate(updatedTransaction);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = TransactionCategories.getCategoriesForType(_type);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать транзакцию'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment<TransactionType>(
                  value: TransactionType.expense,
                  label: Text('Расход'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment<TransactionType>(
                  value: TransactionType.income,
                  label: Text('Доход'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (Set<TransactionType> newSelection) {
                setState(() {
                  _type = newSelection.first;
                  _selectedCategory = TransactionCategories.getDefaultCategoryForType(_type);
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сумма',
                border: OutlineInputBorder(),
                prefixText: '₽',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}