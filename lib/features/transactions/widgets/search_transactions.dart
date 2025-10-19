import 'package:flutter/material.dart';
import '../models/transaction.dart';

class SearchTransactions extends StatefulWidget {
  final List<Transaction> transactions;
  final ValueChanged<List<Transaction>> onSearchResults;

  const SearchTransactions({
    super.key,
    required this.transactions,
    required this.onSearchResults,
  });

  @override
  State<SearchTransactions> createState() => _SearchTransactionsState();
}

class _SearchTransactionsState extends State<SearchTransactions> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void _performSearch(String query) {
    if (query.isEmpty) {
      widget.onSearchResults(widget.transactions);
      return;
    }

    final results = widget.transactions.where((transaction) {
      return transaction.title.toLowerCase().contains(query.toLowerCase()) ||
          transaction.description.toLowerCase().contains(query.toLowerCase()) ||
          transaction.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    widget.onSearchResults(results);
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          labelText: 'Поиск транзакций',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
          )
              : null,
          border: const OutlineInputBorder(),
        ),
        onChanged: _performSearch,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}