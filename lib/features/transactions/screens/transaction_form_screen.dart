import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../data/categories.dart';

class TransactionFormScreen extends StatefulWidget {
  final void Function(
      String title,
      String description,
      double amount,
      TransactionType type,
      String category,
      String? imageUrl, // Добавлен параметр для URL изображения
      ) onSave;
  final VoidCallback onCancel;

  const TransactionFormScreen({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Новый контроллер для URL изображения

  TransactionType _type = TransactionType.expense;
  String _selectedCategory = TransactionCategories.expenseCategories[0];

  @override
  void initState() {
    super.initState();
    _updateCategories();
  }

  void _updateCategories() {
    setState(() {
      _selectedCategory = TransactionCategories.getDefaultCategoryForType(_type);
    });
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

    // Передаем imageUrl (может быть null если пустая строка)
    widget.onSave(
      title,
      description,
      amount,
      _type,
      _selectedCategory,
      imageUrl.isNotEmpty ? imageUrl : null,
    );
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
        title: const Text('Новая транзакция'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Тип транзакции (доход/расход)
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
                  _updateCategories();
                });
              },
            ),

            const SizedBox(height: 20),

            // Поле названия
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название *',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Поле описания
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            // Поле суммы
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

            // Поле URL изображения
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL изображения',
                border: OutlineInputBorder(),
                hintText: 'https://example.com/image.jpg',
              ),
              keyboardType: TextInputType.url,
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

            // Кнопка сохранения
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Добавить транзакцию'),
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
    _imageUrlController.dispose(); // Не забываем освободить новый контроллер
    super.dispose();
  }
}