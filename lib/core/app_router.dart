import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/transactions/presentation/screens/transactions_list_screen.dart';
import '../features/transactions/presentation/screens/statistics_screen.dart';
import '../features/transactions/presentation/screens/transaction_details_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
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
              final transactionId = state.uri.queryParameters['id'] ?? '';
              return TransactionDetailsScreen(transactionId: transactionId);
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const ProfileScreen();
            },
          ),
        ],
      ),
    ],
  );
}