import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/transaction.dart';

class TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<Transaction> onEdit;

  const TransactionRow({
    super.key,
    required this.transaction,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  IconData _getIconForCategory(String category) {
    final icons = {
      'Зарплата': Icons.work,
      'Фриланс': Icons.computer,
      'Инвестиции': Icons.trending_up,
      'Подарок': Icons.card_giftcard,
      'Продукты': Icons.shopping_cart,
      'Транспорт': Icons.directions_car,
      'Развлечения': Icons.movie,
      'Одежда': Icons.checkroom,
      'Здоровье': Icons.local_hospital,
      'Образование': Icons.school,
      'Жилье': Icons.home,
      'Рестораны': Icons.restaurant,
    };
    return icons[category] ?? Icons.receipt;
  }

  @override
  Widget build(BuildContext context) {
    final color = transaction.isExpense ? Colors.red : Colors.green;
    final iconColor = transaction.isExpense ? Colors.red : Colors.green;

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDelete(transaction.id),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(
              _getIconForCategory(transaction.category),
              color: iconColor,
              size: 20,
            ),
          ),
          title: Text(
            transaction.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '${transaction.category} • ${_formatDate(transaction.createdAt)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Минимальный размер по содержимому
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Блок с суммой и типом операции - теперь ЛЕВЕЕ картинки
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Сумма - теперь всегда полностью видима
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 80, // Минимальная ширина для суммы
                    ),
                    child: Text(
                      '${transaction.isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(2)} ₽',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.visible, // Запрещаем обрезку текста
                      softWrap: false, // Запрещаем перенос на новую строку
                    ),
                  ),
                  // Тип операции
                  Text(
                    transaction.type.displayName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),

              const SizedBox(width: 12), // Увеличим отступ между суммой и картинкой

              // Контейнер для изображения (если есть URL)
              if (transaction.imageUrl != null && transaction.imageUrl!.isNotEmpty)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      imageUrl: transaction.imageUrl!,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  color.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeInCurve: Curves.easeIn,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () => onEdit(transaction),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}