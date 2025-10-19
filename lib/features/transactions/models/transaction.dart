class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime createdAt;
  final TransactionType type;
  final String category;
  final String? imageUrl;

  const Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.type,
    required this.category,
    this.imageUrl,
  });

  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? createdAt,
    TransactionType? type,
    String? category,
    String? imageUrl,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Вспомогательные геттеры
  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
}

// Тип транзакции
enum TransactionType {
  income('Доход'),
  expense('Расход');

  const TransactionType(this.displayName);
  final String displayName;
}