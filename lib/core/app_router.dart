import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/transactions/presentation/screens/transactions_list_screen.dart';
import '../features/transactions/presentation/screens/statistics_screen.dart';
import '../features/transactions/presentation/screens/transaction_details_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/transactions/presentation/screens/transaction_form_screen.dart';
import '../features/transactions/presentation/screens/edit_transaction_screen.dart';
import '../features/transactions/data/transaction_model.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const TransactionsListScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'statistics',
            builder: (BuildContext context, GoRouterState state) {
              return const StatisticsScreen();
            },
          ),
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              final transactionId = state.pathParameters['id'] ?? '';
              return TransactionDetailsScreen(transactionId: transactionId);
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const ProfileScreen();
            },
          ),
          GoRoute(
            path: 'add',
            builder: (BuildContext context, GoRouterState state) {
              return TransactionFormScreen(
                onSave: (transaction) {
                  // Обработка сохранения транзакции
                },
              );
            },
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (BuildContext context, GoRouterState state) {
              final id = state.pathParameters['id'] ?? '';
              final transaction = state.extra as Transaction?;
              return EditTransactionScreen(
                transaction: transaction!,
                onUpdate: (updatedTransaction) {
                  // Обработка обновления транзакции
                },
              );
            },
          ),
        ],
      ),
    ],
  );
}