import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../screens/transactions_list_screen.dart';
import '../screens/transaction_form_screen.dart';
import '../screens/edit_transaction_screen.dart';
import '../screens/statistics_screen.dart';

enum Screen { list, form, statistics, edit }

class TransactionsContainer extends StatefulWidget {
  const TransactionsContainer({super.key});

  @override
  State<TransactionsContainer> createState() => _TransactionsContainerState();
}

class _TransactionsContainerState extends State<TransactionsContainer> {
  final List<Transaction> _transactions = [];
  final List<Transaction> _filteredTransactions = [];
  Screen _currentScreen = Screen.list;
  Transaction? _transactionToEdit;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredTransactions.addAll(_transactions);
  }

  void _showList() {
    setState(() {
      _currentScreen = Screen.list;
      _transactionToEdit = null;
    });
  }

  void _showForm() {
    setState(() => _currentScreen = Screen.form);
  }

  void _showStatistics() {
    setState(() => _currentScreen = Screen.statistics);
  }

  void _showEditScreen(Transaction transaction) {
    setState(() {
      _transactionToEdit = transaction;
      _currentScreen = Screen.edit;
    });
  }

  // Методы для поиска
  void _updateSearchResults(List<Transaction> results) {
    setState(() {
      _filteredTransactions.clear();
      _filteredTransactions.addAll(results);
      _isSearching = true;
    });
  }

  void _clearSearch() {
    setState(() {
      _filteredTransactions.clear();
      _filteredTransactions.addAll(_transactions);
      _isSearching = false;
    });
  }

  void _addTransaction(
      String title,
      String description,
      double amount,
      TransactionType type,
      String category,
      String? imageUrl, // Добавлен новый параметр
      ) {
    setState(() {
      final newTransaction = Transaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        description: description,
        amount: amount,
        createdAt: DateTime.now(),
        type: type,
        category: category,
        imageUrl: imageUrl, // Передаем imageUrl в конструктор
      );
      _transactions.insert(0, newTransaction);
      // Обновляем отфильтрованный список
      if (_isSearching) {
        _filteredTransactions.clear();
        _filteredTransactions.addAll(_transactions);
      }
      _currentScreen = Screen.list;
    });
  }

  void _updateTransaction(Transaction updatedTransaction) {
    setState(() {
      final index = _transactions.indexWhere((t) => t.id == updatedTransaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
      }
      // Обновляем отфильтрованный список
      if (_isSearching) {
        final filteredIndex = _filteredTransactions.indexWhere((t) => t.id == updatedTransaction.id);
        if (filteredIndex != -1) {
          _filteredTransactions[filteredIndex] = updatedTransaction;
        }
      }
      _currentScreen = Screen.list;
      _transactionToEdit = null;
    });
  }

  void _toggleTransaction(String id) {
    setState(() {
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        final transaction = _transactions[index];
        _transactions[index] = transaction.copyWith(
          type: transaction.isExpense ? TransactionType.income : TransactionType.expense,
        );
      }
      // Обновляем отфильтрованный список
      if (_isSearching) {
        final filteredIndex = _filteredTransactions.indexWhere((t) => t.id == id);
        if (filteredIndex != -1) {
          final filteredTransaction = _filteredTransactions[filteredIndex];
          _filteredTransactions[filteredIndex] = filteredTransaction.copyWith(
            type: filteredTransaction.isExpense ? TransactionType.income : TransactionType.expense,
          );
        }
      }
    });
  }

  void _deleteTransaction(String id) {
    final transaction = _transactions.firstWhere((t) => t.id == id);

    setState(() {
      _transactions.removeWhere((t) => t.id == id);
      _filteredTransactions.removeWhere((t) => t.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Транзакция "${transaction.title}" удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _transactions.insert(0, transaction);
              if (_isSearching) {
                _filteredTransactions.insert(0, transaction);
              }
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Статистика
  double get _totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get _totalExpenses {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get _balance {
    return _totalIncome - _totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final displayedTransactions = _isSearching ? _filteredTransactions : _transactions;

    switch (_currentScreen) {
      case Screen.list:
        return TransactionsListScreen(
          transactions: displayedTransactions,
          onAdd: _showForm,
          onToggle: _toggleTransaction,
          onDelete: _deleteTransaction,
          onEdit: _showEditScreen,
          balance: _balance,
          totalIncome: _totalIncome,
          totalExpenses: _totalExpenses,
          onShowStatistics: _showStatistics,
          onSearchResults: _updateSearchResults,
          isSearching: _isSearching,
          onClearSearch: _clearSearch,
        );
      case Screen.form:
        return TransactionFormScreen(
          onSave: _addTransaction,
          onCancel: _showList,
        );
      case Screen.statistics:
        return StatisticsScreen(
          transactions: _transactions,
          onBack: _showList,
        );
      case Screen.edit:
        if (_transactionToEdit != null) {
          return EditTransactionScreen(
            transaction: _transactionToEdit!,
            onUpdate: _updateTransaction,
            onCancel: _showList,
          );
        } else {
          // Если по какой-то причине транзакция для редактирования отсутствует,
          // возвращаемся к списку
          return TransactionsListScreen(
            transactions: displayedTransactions,
            onAdd: _showForm,
            onToggle: _toggleTransaction,
            onDelete: _deleteTransaction,
            onEdit: _showEditScreen,
            balance: _balance,
            totalIncome: _totalIncome,
            totalExpenses: _totalExpenses,
            onShowStatistics: _showStatistics,
            onSearchResults: _updateSearchResults,
            isSearching: _isSearching,
            onClearSearch: _clearSearch,
          );
        }
    }
  }
}