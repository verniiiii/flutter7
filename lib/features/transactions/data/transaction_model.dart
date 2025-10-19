import '../../../../core/constants/categories.dart'; // Правильный импорт

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime createdAt;
  final TransactionType type;
  final String category;

  const Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.type,
    required this.category,
  });

  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? createdAt,
    TransactionType? type,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
}