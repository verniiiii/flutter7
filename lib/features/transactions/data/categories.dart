import '../models/transaction.dart';

class TransactionCategories {
  static const List<String> incomeCategories = [
    'Зарплата',
    'Фриланс',
    'Инвестиции',
    'Подарок',
    'Возврат долга',
    'Проценты',
    'Стипендия',
    'Другое'
  ];

  static const List<String> expenseCategories = [
    'Продукты',
    'Транспорт',
    'Развлечения',
    'Одежда',
    'Здоровье',
    'Образование',
    'Жилье',
    'Рестораны',
    'Техника',
    'Подарки',
    'Другое'
  ];

  static List<String> getCategoriesForType(TransactionType type) {
    return type == TransactionType.income ? incomeCategories : expenseCategories;
  }

  static String getDefaultCategoryForType(TransactionType type) {
    return type == TransactionType.income ? incomeCategories[0] : expenseCategories[0];
  }
}


