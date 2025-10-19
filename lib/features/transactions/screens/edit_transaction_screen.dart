import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../data/categories.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;
  final void Function(Transaction) onUpdate;
  final VoidCallback onCancel;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
    required this.onUpdate,
    required this.onCancel,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Новый контроллер для URL изображения

  late TransactionType _type;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.transaction.title;
    _descriptionController.text = widget.transaction.description;
    _amountController.text = widget.transaction.amount.toStringAsFixed(2);
    _type = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    // Инициализируем контроллер URL изображения
    _imageUrlController.text = widget.transaction.imageUrl ?? '';
  }

  void _submit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final imageUrl = _imageUrlController.text.trim(); // Получаем URL изображения

    if (title.isEmpty || amount <= 0) {
      _showError('Заполните название и сумму (больше 0)');
      return;
    }

    // Валидация URL (если поле не пустое)
    if (imageUrl.isNotEmpty) {
      final urlPattern = RegExp(
        r'^(https?://)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*/?$',
        caseSensitive: false,
      );
      if (!urlPattern.hasMatch(imageUrl)) {
        _showError('Введите корректный URL изображения');
        return;
      }
    }

    final updatedTransaction = widget.transaction.copyWith(
      title: title,
      description: description,
      amount: amount,
      type: _type,
      category: _selectedCategory,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null, // Сохраняем URL или null если пусто
    );

    widget.onUpdate(updatedTransaction);
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
          onPressed: widget.onCancel,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Тип транзакции
            SegmentedButton<TransactionType>(
              segments: [
                ButtonSegment<TransactionType>(
                  value: TransactionType.expense,
                  label: const Text('Расход'),
                  icon: const Icon(Icons.arrow_upward),
                ),
                ButtonSegment<TransactionType>(
                  value: TransactionType.income,
                  label: const Text('Доход'),
                  icon: const Icon(Icons.arrow_downward),
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

            // Поле для названия транзакции
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название *',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Поле для описания транзакции
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            // Поле для суммы транзакции
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сумма *',
                border: OutlineInputBorder(),
                prefixText: '₽ ',
              ),
            ),

            const SizedBox(height: 16),

            // Поле для URL изображения (новое поле)
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL изображения',
                border: OutlineInputBorder(),
                hintText: 'https://example.com/image.jpg',
              ),
            ),

            const SizedBox(height: 16),

            // Выбор категории
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

            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text('Отмена'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text('Сохранить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}